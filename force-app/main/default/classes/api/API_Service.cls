@RestResource(urlMapping='/api/*')
global class API_Service {
    private static final API_RequestResolver resolver =
        new API_RequestResolver(RestContext.request);

    private static API_Facade apiFacade = API_Facade.getInstance();

    private static RestResponse createDefaultRestResponse(){
        RestResponse resp = RestContext.response;
        resp.addHeader('Content-Type', 'application/json');
        return resp;
    }

    private static void logPayload(RestRequest req, RestResponse resp, Long responseTime){
        LogEntryEventBuilder myBuilder = Logger.info('HTTP - payload');
        myBuilder.addTag('HTTP_REQUEST');
        myBuilder.addTag(req.httpMethod);
        myBuilder.setRestRequestDetails(req);
        myBuilder.setRestResponseDetails(resp);
        myBuilder.setMessage(buildPayloadTitle(resp, req, responseTime.toString()));
    }

    private static String buildPayloadTitle( RestResponse resp, RestRequest req, String responseTime){
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeFieldName('HTTP_REQUEST');
        gen.writeStartObject();
        gen.writeStringField('requestMethod', resolver.httpMethod);
        gen.writeStringField('requestEndpoint', resolver.apiName);
        gen.writeStringField('requestParams', resolver.urlParams.toString());
        gen.writeStringField('responseStatusCode', resp.statusCode.toString());
        gen.writeStringField('runTime', responseTime);
        gen.writeEndObject();
        gen.writeEndObject();

        return gen.getAsString();
    }

    @HttpGet
    global static void doGet() {
        RestResponse resp = createDefaultRestResponse();

        try{
            Logger.info('doGet()');

            Long startExecution = System.now().getTime();
            resp = apiFacade.doGet(resolver);
            Long responseTime = System.now().getTime() - startExecution;

            logPayload(RestContext.request, resp, responseTime);
        }catch(Exception ex){
            Logger.error('Exception doGet()', ex);

            String jsonException = ExceptionUtil.generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf( jsonException );
        }

        logger.saveLog();
    }
    
    @HttpPost
    global static void doPost() {
        RestResponse resp = createDefaultRestResponse();

        try{
            Logger.info('doPost()');

            Long startExecution = System.now().getTime();
            resp = apiFacade.doPost(resolver);
            Long responseTime = System.now().getTime() - startExecution;

            logPayload(RestContext.request, resp, responseTime);
        }catch(Exception ex){
            Logger.error('Exception doPost()', ex);

            String jsonException = ExceptionUtil.generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf( jsonException );
        }

        logger.saveLog();
    }

    @HttpPut
    global static void doPut() {
        RestResponse resp = createDefaultRestResponse();

        try{
            Logger.info('doPut()');

            Long startExecution = System.now().getTime();
            resp = apiFacade.doPut(resolver);
            Long responseTime = System.now().getTime() - startExecution;

            logPayload(RestContext.request, resp, responseTime);
        }catch(Exception ex){
            Logger.error('Exception doPut()', ex);

            String jsonException = ExceptionUtil.generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf( jsonException );
        }

        logger.saveLog();
    }

    @HttpPatch
    global static void doPatch() {
        RestResponse resp = createDefaultRestResponse();

        try{
            Logger.info('doPatch()');

            Long startExecution = System.now().getTime();
            resp = apiFacade.doPatch(resolver);
            Long responseTime = System.now().getTime() - startExecution;

            logPayload(RestContext.request, resp, responseTime);
        }catch(Exception ex){
            Logger.error('Exception doPatch()', ex);

            String jsonException = ExceptionUtil.generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf( jsonException );
        }

        logger.saveLog();
    }

    @HttpDelete
    global static void doDelete() {
        RestResponse resp = createDefaultRestResponse();

        try{
            Logger.info('doDelete()');

            Long startExecution = System.now().getTime();
            resp = apiFacade.doDelete(resolver);
            Long responseTime = System.now().getTime() - startExecution;

            logPayload(RestContext.request, resp, responseTime);
        }catch(Exception ex){
            Logger.error('Exception doDelete()', ex);

            String jsonException = ExceptionUtil.generateJSONFromException(ex);
            resp.statusCode = 500;
            resp.responseBody = Blob.valueOf( jsonException );
        }

        logger.saveLog();
    }
}