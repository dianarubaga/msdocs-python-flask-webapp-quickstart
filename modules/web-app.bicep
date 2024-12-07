
@description('Required. Name of the site.')
param name string
@description('Optional. Location for all Resources.')
param location string = resourceGroup().location
param kind string = 'app'
@description('Required. The resource ID of the app service plan to use for the site.')

param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'latest'
param appServicePlanId string 

@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string

@description('Optional. The site config object. The defaults are set to the following values: alwaysOn: true, minTlsVersion: \'1.2\', ftpsState: \'FtpsOnly\', linuxFxVersion: \'DOCKER|{containerRegistryName}.azurecr.io/{containerRegistryImageName}:{containerRegistryImageVersion}\', appCommandLine: \'\'.')
param siteConfig object = {
  alwaysOn: true
  minTlsVersion: '1.2'
  ftpsState: 'FtpsOnly'
  linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
  appCommandLine: ''
}

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${containerRegistryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
  { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false'}
]

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: name
  kind : kind
  properties: {
    location: location 
    serverFarmResourceId : appServicePlanId
    siteConfig: siteConfig
    dockerAppSettings: dockerAppSettings
  }
}



