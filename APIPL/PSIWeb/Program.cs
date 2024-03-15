using Core.BaseUtility.Extensions;
using Core.BaseUtility.Utility;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Http.Features;
using PSI.Modules.Backends.Masters.Services.Validator.AccountMaster;
using PSI.Modules.Backends.WebApi.Results;
using PSIWeb.Extensions;
using Serilog;
using SessionManagers.Extension;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

LoggerConfig.Configure(builder.Configuration);
builder.Host.UseSerilog();
// Add services to the container.
builder.Services.AddCors(options =>{
    options.AddPolicy(name: "FCPLCors",
                      policy =>
                      {
                          policy.WithOrigins("http://localhost:4200",
                                              "https://10.101.2.133",
                                              "https://10.101.37.6")
                          .AllowAnyHeader()
                          .AllowAnyMethod()
                          .AllowCredentials()
                          .WithExposedHeaders("Content-Disposition");
                      });
});
builder.Services
    .AddHttpContextAccessor()
    .AddAzureAdAuthentication(builder.Configuration)
    .ServiceResolver()
    .AddResponseCaching()
    .AddMemoryCache()
    .AddSwagger()
    .AddControllers()
    .AddXmlSerializerFormatters();
builder.Services.AddValidatorsFromAssemblyContaining<MenuValidator>() // register validators
    .AddFluentValidationAutoValidation(); // the same old MVC pipeline behavior

builder.Services.Configure<FormOptions>(o =>
{
    o.ValueLengthLimit = int.MaxValue;
    o.MultipartBodyLengthLimit = int.MaxValue;
    o.MemoryBufferThreshold = int.MaxValue;
});


builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssemblies(Assembly.GetExecutingAssembly()));

builder.Services.AddMvc();

builder.Services.AddAutoMapper(typeof(ProductCategoryMappingProfile));

var app = builder.Build();

ConfigHelper.AppConfigHelper(app.Services.GetRequiredService<IConfiguration>());
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
HttpContextHandler.Configure(app.Services.GetRequiredService<IHttpContextAccessor>());
app.UseHttpsRedirection();
app.UseRouting();
app.UseCors("FCPLCors");
app.UseAuthentication();
app.UseAuthorization();
app.UseEndpoints(endpoints => {
    endpoints.MapControllers();
});


app.Run();
