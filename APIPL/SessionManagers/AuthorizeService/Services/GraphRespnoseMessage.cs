using Newtonsoft.Json;

namespace SessionManagers.AuthorizeService.Services
{
    public class GraphRespnoseMessage
    {
        public Error error { get; set; }
    }
    public class Detail
    {
        public string code { get; set; }
        public string message { get; set; }
        public string target { get; set; }
    }

    public class Error
    {
        public string code { get; set; }
        public string message { get; set; }
        public List<Detail> details { get; set; }
        public InnerError innerError { get; set; }
    }

    public class InnerError
    {
        public DateTime date { get; set; }

        [JsonProperty("request-id")]
        public string requestid { get; set; }

        [JsonProperty("client-request-id")]
        public string clientrequestid { get; set; }
    }


}
