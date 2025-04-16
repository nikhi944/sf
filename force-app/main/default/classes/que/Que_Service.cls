public with sharing class Que_Service {
    private static Que_Service INSTANCE = null;

    @TestVisible
    private static Que_SOQL SOQL = Que_SOQL.getInstance();

    @TestVisible
    private static DML_IOperations DML = DML_Executor.getInstance();

    //private constructor to avoid creating an instance
    private Que_Service() {
    }

    public static Que_Service getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new Que_Service();
        }

        return instance;
    }

    // Preventing system from overloadingelse and ensures that we only have one queueable running/user
    public Id startQueueable(Id currentJobId) {
        Logger.info(new LogMessage('startQueueable({0})', currentJobId));

        try {
            if (isAsyncRequestPending()) {
                List<AsyncApexJob> jobs = SOQL.getRunningQueueableJobs();

                if (jobs.size() >= 1 || (jobs.size() == 1 && jobs[0].Id != currentJobId)) {
                    return null; // Already have one queued by this user - don't need another
                }

                if (Limits.GetLimitQueueableJobs() - Limits.GetQueueableJobs() > 0) {
                    AsyncOptions options = new AsyncOptions();
                    options.DuplicateSignature = QueueableDuplicateSignature.Builder()
                        .addId(UserInfo.getUserId())
                        .addString('Que_Service')
                        .build();

                    try {
                        return System.enqueueJob(new Que_Queueable(), options);
                    } catch (DuplicateMessageException ex) {
                        Logger.warn('Attempt to enqueue job with duplicate queueable signature', ex);
                    }
                }
            }
        } catch (Exception ex) {
            Logger.error(new LogMessage('Exception startQueueable({0})', currentJobId), ex);
            
            throw ex;
        }

        return null;
    }

    // Determine if another asynch request is pending - which means we should chain
    public Boolean isAsyncRequestPending() {
        Logger.info('isAsyncRequestPending()');
        return !SOQL.getPendingAsyncRequests().isEmpty();
    }

    public void executeAsyncRequest(Que_AsyncRequest__c asyncRequestToExecute) {
        Logger.info(new LogMessage('executeAsyncRequest({0})', asyncRequestToExecute), asyncRequestToExecute.Id);
        Boolean success = true;
        Exception executionException = null;
        try {
            Type t = Type.forName(asyncRequestToExecute.Que_Executor__c);
            Que_IExecutable asyncExecutor = (Que_IExecutable) t.newInstance();

            try {
                asyncRequestToExecute.Que_ExecutionStartDate__c = System.now();
                asyncExecutor.execute(asyncRequestToExecute);
                asyncRequestToExecute.Que_ExecutionEndDate__c = System.now();
            } catch (Exception ex) {
                success = false;
                executionException = ex;

                //Logg the exception on the asyncrequest
                Logger.error(
                    new LogMessage('exception executeAsyncRequest({0})', asyncRequestToExecute),
                    asyncRequestToExecute.Id,
                    ex
                );
            }

            //There are cases where the lock is released (the queueable has a callout)
            SOQL.getAsyncRequestForUpdateById(asyncRequestToExecute.Id);

            if (!success) {
                asyncRequestToExecute.Que_Status__c = 'WaitForResume';
                asyncRequestToExecute.Que_Error__c = true;
                asyncRequestToExecute.Que_ErrorCount__c += 1;

                //Write the exception as JSON to the Que_ErrorMessage__c field
                asyncRequestToExecute.Que_ErrorMessage__c = ExceptionUtil.generateJSONFromException(executionException);

                //Check if we want to retry the asyncrequest
                if (asyncRequestToExecute.Que_ErrorCount__c <= 4) {
                    Boolean shouldExecutorRetry = asyncExecutor.retryOnException(
                        asyncRequestToExecute,
                        executionException
                    );

                    if (shouldExecutorRetry) {
                        asyncRequestToExecute.Que_Status__c = 'In progress';
                    }
                }
            } else {
                asyncRequestToExecute.Que_Status__c = 'Completed';
                asyncRequestToExecute.Que_Error__c = false;
                asyncRequestToExecute.Que_ErrorMessage__c = null;
            }
        } catch (Exception ex) {
            asyncRequestToExecute.Que_Status__c = 'WaitForResume';
            asyncRequestToExecute.Que_Error__c = true;
            asyncRequestToExecute.Que_ErrorCount__c += 1;
            asyncRequestToExecute.Que_ErrorMessage__c = ex.getMessage();

            Logger.error(
                new LogMessage('Exception executeAsyncRequest({0})', asyncRequestToExecute),
                asyncRequestToExecute.Id,
                ex
            );
        } finally {
            Boolean dmlSuccess = false;
            for (Integer i = 0; i < 5; i++) {
                try {
                    DML.doUpdate(asyncRequestToExecute);
                    dmlSuccess = true;
                    break; //The dml was succesfull
                } catch (Exception ex) {
                    // Process exception here
                    Logger.error(
                        new LogMessage(
                            'Update AsyncRequest: {0} failed. Retrying DML iteration {1}',
                            asyncRequestToExecute,
                            i
                        ),
                        asyncRequestToExecute.Id,
                        ex
                    );
                }
            }

            if (!dmlSuccess) {
                Logger.saveLog();
            }
        }
    }
}