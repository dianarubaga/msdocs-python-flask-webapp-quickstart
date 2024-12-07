@description('Required. The name of the Azure Web App.')
param name string

@description('Optional. The location of the Web App.')
param location string = resourceGroup().location

@description('Optional. The kind of Web App (e.g., "app").')
param kind string = 'app'

@description('Required. The resource ID of the associated App Service Plan.')
param serverFarmResourceId string

@description('The name of the Azure Container Registry.')
param containerRegistryName string

@description('The name of the Docker image in the registry.')
param containerRegistryImageName string

@description('The version of the Docker image.')
param containerRegistryImageVersion string

@description('Required. The configuration for the Web App.')
param siteConfig object = {
  linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
  appCommandLine: ''
}

@description('Optional. The application settings for the Web App.')
param appSettingsKeyValuePairs object = {
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
  DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryName}.azurecr.io'
  DOCKER_REGISTRY_SERVER_USERNAME: '<your-username>'
  DOCKER_REGISTRY_SERVER_PASSWORD: '<your-password>'
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: webApp
  name: 'appsettings'
  properties: appSettingsKeyValuePairs
}

@description('The URL of the deployed Azure Web App.')
output webAppUrl string = webApp.properties.defaultHostName
