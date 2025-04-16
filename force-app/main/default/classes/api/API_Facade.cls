public class API_Facade {
    private static API_Facade INSTANCE = null;

    private API_Facade() {
    }

    //This mapping should probably move to custom metadata
    public Map<String, String> apiNameToHandlerClass = new Map<String, String>{
        'CleanAddress' => 'DAR_CleanAddressAPI',
        'vasky' => 'DAR_CleanAddressAPI',
        'vasky/asdas' => 'DAR_CleanAddressAPI',
        'sync/account' => 'SYNC_AccountAPI'
    };

    public static API_Facade getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new API_Facade();
        }

        return instance;
    }

    public RestResponse doDelete(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doDelete({0})', resolver));
        return this.getHandler(resolver.apiName).doDelete(resolver);
    }

    public RestResponse doGet(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doGet({0})', resolver));
        return this.getHandler(resolver.apiName).doGet(resolver);
    }

    public RestResponse doPatch(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPatch({0})', resolver));
        return this.getHandler(resolver.apiName).doPatch(resolver);
    }

    public RestResponse doPost(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPost({0})', resolver));
        return this.getHandler(resolver.apiName).doPost(resolver);
    }

    public RestResponse doPut(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPut({0})', resolver));
        return this.getHandler(resolver.apiName).doPut(resolver);
    }

    public API_Handler getHandler(String apiName) {
        Logger.info(new LogMessage('getHandler({0})', apiName));
        Type handlerType;
        if(!apiNameToHandlerClass.containsKey(apiName)){
            Logger.info('returning default handler for key: '+ apiName);
            return new API_Handler();
        }else{
            handlerType = Type.forName(apiNameToHandlerClass.get(apiName));
            Logger.info('handlerType returned: ' + handlerType);
        }
        
        return (API_Handler) handlerType.newInstance();
    }
}