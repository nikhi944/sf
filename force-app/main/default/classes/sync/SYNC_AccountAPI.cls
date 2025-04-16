global with sharing class SYNC_AccountAPI extends API_Handler {
    private static DML_IOperations DML = DML_Executor.getInstance();

    public override RestResponse doPost(API_RequestResolver resolver) {
        Logger.info(new LogMessage('doPost({0})', resolver));

        List<SYNC_AccountDTO> accountDTOs = parse(RestContext.request.requestBody.toString());

        Map<SObjectField, List<SObject>> toPersist = mapToSobjects(accountDTOs);

        List<SYNC_ErrorDTO> syncErrors = persist(toPersist);

        //parseValidateMapPersist(RestContext.request);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(syncErrors));
        res.statusCode = 200;
        
        return res;
    }

    public List<SYNC_ErrorDTO> persist(Map<SObjectField, List<SObject>> toPersist){
        List<Account> accounts = (List<Account>) toPersist.get(Account.ExternalId__c);
        Database.DMLOptions opt = new Database.DMLOptions();
        opt.OptAllOrNone = false;
        DML.setOptions(opt, null);
        
        List<Database.UpsertResult> results = DML.doUpsert(accounts, Account.ExternalId__c);

        List<SYNC_ErrorDTO> failedSync = new List<SYNC_ErrorDTO>();
        for(Integer index = 0; index<results.size(); index++){
            Database.UpsertResult result = results.get(index);
            Account failedAccount = accounts.get(0);

            if(!result.isSuccess()){
                SYNC_ErrorDTO fail = new SYNC_ErrorDTO();
                fail.uuid = failedAccount.ExternalId__c;
                fail.errorMessage = result.getErrors().toString();
                failedSync.add(fail);
            }
        }

        return failedSync;
    }

    public List<SYNC_AccountDTO> parse(String requestBody){
        List<SYNC_AccountDTO> accountsDTO = new List<SYNC_AccountDTO>();
        try {
            accountsDTO = (List<SYNC_AccountDTO>) JSON.deserialize(requestBody, List<SYNC_AccountDTO>.class);
        } catch (Exception ex) {
        }

        return accountsDTO;
    }

    public Map<SObjectField, List<SObject>> mapToSobjects(List<SYNC_AccountDTO> accs){
        Map<SObjectField, List<SObject>> sobjectsMap = new Map<SObjectField, List<SObject>>();

        sobjectsMap.put(Account.ExternalId__c, new List<Account>());

        for(SYNC_AccountDTO accDTO : accs){
            Account acc = new Account();
            acc.Name = accDTO.name;
            acc.ExternalId__c = accDTO.uuid;

            sobjectsMap.get(Account.ExternalId__c).add(acc);
        }

        return sobjectsMap;
    }


}