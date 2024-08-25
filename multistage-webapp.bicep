var appServicePlanName = 'tailspin-multistage-asp'
var webAppPrefix = 'tailspin-webapp-'
var location = 'eastus'
var sku = 'F1'
var environments = [
  'dev'
  'test'
  'stage'
  'prod'
]

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: false // Windows
  }
  sku: {
    name: sku
  }
}

resource webApps 'Microsoft.Web/sites@2023-12-01' = [
  for env in environments: {
    name: '${webAppPrefix}${env}'
    location: location
    properties: {
      serverFarmId: appServicePlan.id
      siteConfig: {
        netFrameworkVersion: 'v8.0' //
      }
    }
  }
]

resource aspNetCore8Support 'Microsoft.Web/sites/siteextensions@2022-09-01' = [
  for i in range(0, length(environments)): {
    parent: webApps[i]
    name: 'AspNetCoreRuntime.8.0.x86'
  }
]
