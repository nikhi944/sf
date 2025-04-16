public with sharing class Que_AsyncRequestTriggerHandler extends TriggerHandler {
    private static final Que_Service SERVICE_QUE = Que_Service.getInstance();
    private static DML_IOperations DML = DML_Executor.getInstance();


    private List<Que_AsyncRequest__c> triggerNew;
    private List<Que_AsyncRequest__c> triggerOld;
    private Map<Id, Que_AsyncRequest__c> triggerMapNew;
    private Map<Id, Que_AsyncRequest__c> triggerMapOld;

    public Que_AsyncRequestTriggerHandler(){
        this.triggerOld = (List<Que_AsyncRequest__c>) Trigger.old;
        this.triggerNew = (List<Que_AsyncRequest__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, Que_AsyncRequest__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, Que_AsyncRequest__c>) Trigger.oldMap;
    }

    public override void afterUpdate() {
        Logger.info('afterUpdate()');
        List<Que_AsyncRequest__c> reconstructedRequests = new List<Que_AsyncRequest__c>();


        for(Id asyncRequestId : triggerMapNew.keySet()){
            Que_AsyncRequest__c oldObject = triggerMapOld.get(asyncRequestId);
            Que_AsyncRequest__c newObject = triggerMapNew.get(asyncRequestId);

            if(newObject.Que_Status__c == 'Reconstructed' && oldObject.Que_Status__c != newObject.Que_Status__c){
                Que_AsyncRequest__c reconstructedAsyncRequest = newObject.clone(false, false, false, false);
                reconstructedAsyncRequest.Que_Status__c = 'In Progress';

                reconstructedRequests.add(reconstructedAsyncRequest);
            }
        }

        if(!reconstructedRequests.isEmpty()){
            DML.doInsert(reconstructedRequests);
        }
    }

    public override void afterInsert() {
        Logger.info('afterInsert()');
        if (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0){
            try {
                SERVICE_QUE.startQueueable(null);
            } catch (Exception ex) {
                // Ignore for now
            }
        }
    }
}