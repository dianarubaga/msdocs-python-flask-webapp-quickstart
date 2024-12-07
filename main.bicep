// Parameters
@description('Location for resources.')
param location string

@description('Name of the Azure Container Registry.')
param containerRegistryName string

@description('Name of the App Service Plan.')
param appServicePlanName string

@description('Name of the Web App.')
param webAppName string

@description('Container image name.')
param containerRegistryImageName string

@description('Container image version.')
param containerRegistryImageVersion string

@description('Specifies the SKU for the App Service Plan.')
param sku object

// Azure Container Registry Deployment
module containerRegistry './modules/cont.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    name: containerRegistryName // Reference from parameters
    location: location // Reference from parameters
    acrAdminUserEnabled: true
  }
}

// Azure App Service Plan Deployment
module appServicePlan './modules/app-service.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName // Reference from parameters
    location: location // Reference from parameters
    sku: sku // Reference from parameters
    kind: 'Linux'
    reserved: true
  }
}

// Azure Web App Deployment
module webApp './modules/web-app.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: webAppName // Reference from parameters
    location: location // Reference from parameters
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.resourceId // Output from App Service Plan module
    containerRegistryName: containerRegistry.outputs.loginServer // Output from Container Registry module
    containerRegistryImageName: containerRegistryImageName // Reference from parameters
    containerRegistryImageVersion: containerRegistryImageVersion // Reference from parameters
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: containerRegistry.outputs.loginServer
      DOCKER_REGISTRY_SERVER_USERNAME: containerRegistry.outputs.adminUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: containerRegistry.outputs.adminPassword
    }
  }
}
