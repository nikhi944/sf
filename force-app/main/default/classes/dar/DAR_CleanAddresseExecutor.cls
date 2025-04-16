public with sharing class DAR_CleanAddresseExecutor implements Que_IExecutable {
    private static DAR_Client DAR_REST_CLIENT = DAR_Client.getInstance();

    public void execute(Que_AsyncRequest__c asyncRequest){
        Logger.info(new LogMessage('execute({0})', asyncRequest), asyncRequest.Id);

        HttpResponse httpResp = DAR_REST_CLIENT.addresseVask(asyncRequest.Que_Params__c);
    }

    public Boolean retryOnException(Que_AsyncRequest__c asyncRequest, Exception ex){
        String exceptionAsJSON = ExceptionUtil.generateJSONFromException(ex);
        Logger.info(new LogMessage('retryOnException({0})', asyncRequest, exceptionAsJSON), asyncRequest.Id);
        return true;
    }
}