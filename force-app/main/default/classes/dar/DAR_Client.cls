public with sharing class DAR_Client extends RestClient{
    private static String NAMED_CREDENTIAL = 'DAR_Client';
    private static DAR_Client INSTANCE = null;  


    public static String ENDPOINT_DATAVASK { get { return 'Hello World'; } }

    //private constructor to avoid creating an instance
    private DAR_Client() {
        super(NAMED_CREDENTIAL);
    }

    public static DAR_Client getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new DAR_Client();
        }

        return instance;
    }

    public HttpResponse addresseVask(String address){
        Logger.info(new LogMessage('addresseVask({0})', address));
        String dataVaskEndpoint = String.format( Endpoint__mdt.getInstance('DAR_Client_Datavask').URL__c, new List<Object>{EncodingUtil.urlEncode(address, 'UTF-8')});

        return this.makeApiCall(HttpVerb.GET, dataVaskEndpoint);
    }

}