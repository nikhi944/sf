public with sharing class Que_SOQL {
    //private static instance of the class
    private static Que_SOQL instance = null;

    //private constructor to avoid creating an instance
    //TestVisible to be able to mock
    public Que_SOQL() {
    }

    public static Que_SOQL getInstance() {
        if (instance == null) {
            instance = new Que_SOQL();
        }

        return instance;
    }

    public List<AsyncApexJob> getRunningQueueableJobs() {
        Logger.info(new LogMessage('getRunningJobs() - userinfo.getUserID: {0}', userinfo.getUserID()));

        return [
            SELECT Id, Status, ExtendedStatus
            FROM AsyncApexJob
            WHERE
                JobType = 'Queueable'
                AND (status = 'Queued'
                OR Status = 'Holding')
                AND CreatedById = :userinfo.getUserID()
                AND ApexClass.Name = 'Que_Queueable'
            WITH SECURITY_ENFORCED
        ];
    }

    public List<Que_AsyncRequest__c> getPendingAsyncRequests() {
        Logger.info('getPendingAsyncRequests()');

        return [
            SELECT
                Id,
                Que_Executor__c,
                Que_Params__c,
                Que_ErrorCount__c,
                Que_Status__c,
                Que_ExecutionEndDate__c,
                Que_ExecutionStartDate__c
            FROM Que_AsyncRequest__c
            WHERE Que_Status__c = 'In progress' AND CreatedById = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }

    public List<Que_AsyncRequest__c> getAsyncRequestsForUpdate() {
        Logger.info('getAsyncRequestsForUpdate()');

        return [
            SELECT
                Id,
                Que_Executor__c,
                Que_Params__c,
                Que_ErrorCount__c,
                Que_Status__c,
                Que_ExecutionEndDate__c,
                Que_ExecutionStartDate__c
            FROM Que_AsyncRequest__c
            WHERE Que_Status__c = 'In progress' AND CreatedById = :UserInfo.getUserId()
            WITH SECURITY_ENFORCED
            LIMIT 1
            FOR UPDATE
        ];
    }

    public List<Que_AsyncRequest__c> getAsyncRequestForUpdateById(Id asyncRequestId) {
        Logger.info(new LogMessage('getAsyncRequestForUpdateById({0})', asyncRequestId), asyncRequestId);

        return [
            SELECT
                Id
            FROM Que_AsyncRequest__c
            WHERE Que_Status__c = 'In progress' AND Id = :asyncRequestId
            WITH SECURITY_ENFORCED
            FOR UPDATE
        ];
    }
}