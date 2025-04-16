public without sharing class Que_Queueable implements Queueable, Database.AllowsCallouts {
    private static final Que_SOQL SOQL = Que_SOQL.getInstance();
    private static final Que_Service SERVICE_QUE = Que_Service.getInstance();

    public void execute(QueueableContext context) {
        Logger.info(
            new LogMessage('execute({0})', context)
        );
        Logger.setAsyncContext(context);

        try{
            List<Que_AsyncRequest__c> requests = SOQL.getAsyncRequestsForUpdate();

            //If we don't have any requests to process exit
            if (requests.isEmpty()) {
                return;
            }
    
            Que_AsyncRequest__c currentRequest = requests[0];
    
            Que_Finalizer finalizer = new Que_Finalizer();
            finalizer.setAsyncRequestId(currentRequest.Id);
            System.attachFinalizer(finalizer);
            
            SERVICE_QUE.executeAsyncRequest(currentRequest);
    
        }catch(Exception ex){
            Logger.error(
                new LogMessage('execute({0})', context, ex)
            );

            Logger.saveLog();
        }
        Logger.saveLog();

        
    }
}