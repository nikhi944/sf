global with sharing class DAR_CleanAddressAPI extends API_Handler {

    public override RestResponse doGet(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doGet({0})', resolver));

        RestResponse res = RestContext.response;
        List<Account> accounts = [SELECT Id, Name FROM Account limit 10];
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(accounts));
        res.statusCode = 200;
        
        return res;
    }
}