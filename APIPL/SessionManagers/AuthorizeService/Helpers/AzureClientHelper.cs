using Microsoft.Azure.ActiveDirectory.GraphClient.Extensions;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.Graph;

using Microsoft.IdentityModel.Clients.ActiveDirectory;
using SessionManagers.Results;
using System.Net.Http.Headers;

namespace SessionManagers.AuthorizeService.Helpers
{
    public static class AzureClientHelper
    {
        public static async Task<GraphServiceClient> GetGraphApiClient(IConfiguration configuration, IMemoryCache _cache)
        {
            

           var accesstoken = _cache.Get<TokenResult>(key: "graphAccessToken");
            if (accesstoken == null || accesstoken.ExpiresOn<DateTime.UtcNow)
            {
                var credentials = new ClientCredential(configuration["AppConfig:FrontEndClientId"],
                    configuration["AppConfig:ClientSecret"]);

                var authContext =
                    new AuthenticationContext($"https://login.microsoftonline.com/{configuration["AzureAD:TenantId"]}/");

                var token = await authContext
                     .AcquireTokenAsync("https://graph.microsoft.com/", credentials);

                accesstoken =  new TokenResult();
                accesstoken.ExpiresOn = token.ExpiresOn;
                accesstoken.Token=token.AccessToken;

                _cache.Set("graphAccessToken", accesstoken, TimeSpan.FromDays(24));
            }

            var graphServiceClient = new GraphServiceClient(new DelegateAuthenticationProvider((requestMessage) =>
            {
                requestMessage
                    .Headers
                    .Authorization = new AuthenticationHeaderValue("bearer", accesstoken.Token);

                return Task.CompletedTask;
            }));
            _cache.Set("graphServiceClient", graphServiceClient, TimeSpan.FromHours(24));
            return graphServiceClient;
        }

        public static async Task<GraphServiceClient> GetGraphClientBackend(IConfiguration configuration, IMemoryCache _cache)
        {


            var accesstoken = _cache.Get<TokenResult>(key: "graphAccessTokenBackend");
            if (accesstoken == null || accesstoken.ExpiresOn < DateTime.UtcNow)
            {
                var credentials = new ClientCredential(configuration["AppConfig:BackendClientId"],
                    configuration["AppConfig:ClientSecretBackend"]);

                var authContext =
                    new AuthenticationContext($"https://login.microsoftonline.com/{configuration["AzureAD:TenantId"]}/");

                var token = await authContext
                     .AcquireTokenAsync("https://graph.microsoft.com/", credentials);

                accesstoken = new TokenResult();
                accesstoken.ExpiresOn = token.ExpiresOn;
                accesstoken.Token = token.AccessToken;

                _cache.Set("graphAccessTokenBackend", accesstoken, TimeSpan.FromDays(24));
            }

            var graphServiceClient = new GraphServiceClient(new DelegateAuthenticationProvider((requestMessage) =>
            {
                requestMessage
                    .Headers
                    .Authorization = new AuthenticationHeaderValue("bearer", accesstoken.Token);

                return Task.CompletedTask;
            }));
            _cache.Set("graphServiceClientBackend", graphServiceClient, TimeSpan.FromHours(24));
            return graphServiceClient;
        }
        public static async Task<string> GetTokenForApplication(IConfiguration configuration)
        {
            string TokenForApplication = "";

            AuthenticationContext authenticationContext = new AuthenticationContext(
                $"https://login.microsoftonline.com/{configuration["AzureAD:TenantId"]}",
                false);

            // Configuration for OAuth client credentials 

            ClientCredential clientCred = new ClientCredential(configuration["AppConfig:FrontEndClientId"],
               configuration["AppConfig:ClientSecret"]
                );
            AuthenticationResult authenticationResult =
                await authenticationContext.AcquireTokenAsync("https://graph.windows.net", clientCred);
            TokenForApplication = authenticationResult.AccessToken;

            return TokenForApplication;
        }

        public static async Task<string> GetTokenForApplicationBackend(IConfiguration configuration)
        {
            string TokenForApplication = "";

            AuthenticationContext authenticationContext = new AuthenticationContext(
                $"https://login.microsoftonline.com/{configuration["AzureAD:TenantId"]}",
                false);

            // Configuration for OAuth client credentials 

            ClientCredential clientCred = new ClientCredential(configuration["AppConfig:BackendClientId"],
               configuration["AppConfig:ClientSecretBackend"]
                );
            AuthenticationResult authenticationResult =
                await authenticationContext.AcquireTokenAsync("https://graph.windows.net", clientCred);
            TokenForApplication = authenticationResult.AccessToken;

            return TokenForApplication;
        }





    }

}
