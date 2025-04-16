public interface Que_IExecutable {
    void execute(Que_AsyncRequest__c request);
    Boolean retryOnException(Que_AsyncRequest__c request, Exception ex);
}