using AttachmentService;
using PSI.Domains;
using PSI.Modules.Backends.BWIntegration;
using PSI.Modules.Backends.Masters.Repository.AccountMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using Scrutor;
using SessionManagers.AuthorizeService.Services;

namespace PSIWeb.Extensions
{
    public static class DependencyInjectionExtension
    {
        public static IServiceCollection ServiceResolver(this IServiceCollection services)
        {
            services.Scan(sc => sc.FromCallingAssembly().FromAssemblies
             (
                 typeof(IAccountRepository).Assembly,
                 typeof(IAzureAppServices).Assembly,
                 typeof(IAttachmentService).Assembly
                

             )
             .AddClasses(@class =>
                          @class.Where(type =>
                           !(type.Name.StartsWith('I')
                           || type.Name.EndsWith("Command")
                           || type.Name.EndsWith("Query"))

            )).UsingRegistrationStrategy(RegistrationStrategy.Skip)
             .AsImplementedInterfaces()
             .WithScopedLifetime()); 
            return services;
            
        }
    }
}
