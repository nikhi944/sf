public virtual class API_Handler {
    public static final String BASIC_RESPONSE = 'HTTP method not yet implemented';

    //enforce zero argument constructor
    public API_Handler() {
    }

    public virtual RestResponse doDelete(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doDelete({0})', resolver));
        return getResponse(BASIC_RESPONSE);
    }
    public virtual RestResponse doGet(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doGet({0})', resolver));
        return getResponse(BASIC_RESPONSE);
    }
    public virtual RestResponse doPatch(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPatch({0})', resolver));
        return getResponse(BASIC_RESPONSE);
    }
    public virtual RestResponse doPost(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPost({0})', resolver));
        return getResponse(BASIC_RESPONSE);
    }
    public virtual RestResponse doPut(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPut({0})', resolver));
        return getResponse(BASIC_RESPONSE);
    }

    protected RestResponse getResponse(String responseBody) {
        RestResponse res =  RestContext.response;
        
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
        return res;
    }
}