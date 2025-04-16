public with sharing class Que_ExecutorExample implements Que_IExecutable {
    public void execute(Que_AsyncRequest__c asyncRequest){
        Logger.info(new LogMessage('execute({0})', asyncRequest), asyncRequest.Id);

        if(asyncRequest.Que_Params__c == 'Exception'){
            String s;
            s.charat(5);
        }
    }

    public Boolean retryOnException(Que_AsyncRequest__c asyncRequest, Exception ex){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('exceptionType', ex.getTypeName());
        gen.writeStringField('message', ex.getMessage());
        gen.writeStringField('stackTrace', ex.getStackTraceString());
        gen.writeNumberField('lineNumber', ex.getLineNumber());
        gen.writeEndObject();
        String exceptionAsJSON = gen.getAsString();

        Logger.info(new LogMessage('attemptRetryOnException({0}, {1})', asyncRequest, exceptionAsJSON), asyncRequest.Id);
        return true;
    }
}