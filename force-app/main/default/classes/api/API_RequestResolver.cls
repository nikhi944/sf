public class API_RequestResolver {
    private final String apiBase = '/api/';

    public String apiName { get; private set; }
    public String httpMethod {get; private set; }
    public String requestBody { get; private set; }
    public Map<String, String> urlParams { get; private set; }

    public API_RequestResolver(RestRequest req) {
        LOGGER.INFO(new LogMessage('API_RequestResolver({0})', req));

        this.ApiName = req.requestURI.remove(apiBase);
        this.RequestBody = req.requestBody != null ? req.requestBody.toString() : '';
        this.urlParams = req.params;
        this.httpMethod = req.httpMethod;
    }
}