public with sharing class ExceptionUtil {
    public static String generateJSONFromException(Exception ex) {
        //Write the exception as JSON object to the Que_ErrorMessage__c field
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('exceptionType', ex.getTypeName());
        gen.writeStringField('message', ex.getMessage());
        gen.writeStringField('stackTrace', ex.getStackTraceString());
        gen.writeNumberField('lineNumber', ex.getLineNumber());
        gen.writeEndObject();

        String exceptionAsJSON = gen.getAsString();

        logger.info(new LogMessage('generateJSONFromException({0})', exceptionAsJSON));

        return exceptionAsJSON;
    }
}