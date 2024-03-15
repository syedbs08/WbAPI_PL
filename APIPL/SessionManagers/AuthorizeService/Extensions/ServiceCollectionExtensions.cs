
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using Microsoft.AspNetCore.Builder;
using Microsoft.OpenApi.Models;

namespace AuthenticatioService.Extensions
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddAzureAdAuthentication(this IServiceCollection services, IConfiguration Configuration)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddMicrosoftIdentityWebApi(Configuration);
            services.AddAuthorization();
            return services;
        }
        public static IServiceCollection AddCookiesPolicy(this IServiceCollection services)
        {
            services.Configure<CookiePolicyOptions>(options =>
            {
                options.CheckConsentNeeded = context => true; // consent required
                options.MinimumSameSitePolicy = SameSiteMode.None;
            });

            return services;
        }
        public static IServiceCollection AddSwagger(this IServiceCollection services)
            => services
                  .AddSwaggerGen(c =>
                  {
                      c.SwaggerDoc("v1", new OpenApiInfo
                      {
                          Title = "Adhar Verificcation apis",
                          Version = "v1",
                          Description = "Adhar Verificcation  api ",

                      });
                      c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                      {
                          In = ParameterLocation.Header,
                          Description = "Please insert JWT with Bearer into field",
                          Name = "Authorization",
                          Type = SecuritySchemeType.ApiKey
                      });
                      c.AddSecurityRequirement(new OpenApiSecurityRequirement {
                       {
                         new OpenApiSecurityScheme
                         {
                           Reference = new OpenApiReference
                           {
                             Type = ReferenceType.SecurityScheme,
                             Id = "Bearer"
                           }
                          },
                          new string[] { }
                        }
                      });
                  });

    }
}
