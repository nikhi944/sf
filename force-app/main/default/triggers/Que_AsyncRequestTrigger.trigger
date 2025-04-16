trigger Que_AsyncRequestTrigger on Que_AsyncRequest__c (after insert, after update) {
    new Que_AsyncRequestTriggerHandler().run();
}