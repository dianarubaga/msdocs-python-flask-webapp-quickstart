param webAppName string
param location string = resourceGroup().location
param appServicePlanId string
param containerRegistryName string
@secure()
param containerRegistryUsername string
@secure()
param containerRegistryPassword string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'latest'
param additionalAppSettings array = []

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${containerRegistryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: containerRegistryUsername }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: containerRegistryPassword }
  { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false' }
]

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
      appSettings: union(additionalAppSettings, dockerAppSettings)
    }
  }
}

output webAppUrl string = webApp.properties.defaultHostName
