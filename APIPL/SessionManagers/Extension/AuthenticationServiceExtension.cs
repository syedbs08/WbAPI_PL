using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Identity.Web;


namespace SessionManagers.Extension
{
    public static class AuthenticationServiceExtension
    {
        public static IServiceCollection AddAzureAdAuthentication(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
          .AddMicrosoftIdentityWebApi(options =>
          {
              configuration.Bind("AzureAD", options);

              options.TokenValidationParameters.NameClaimType = "name";
          },
           options => { configuration.Bind("AzureAD", options); });
            services.AddAuthorization();
            return services;



        }
    
    }
}
