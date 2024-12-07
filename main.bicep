// Azure Container Registry Deployment
module containerRegistry './modules/cont.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    name: 'DianaContainerRegistry'
    location: 'EastUS'
    acrAdminUserEnabled: true
  }
}

// Azure App Service Plan Deployment
module appServicePlan './modules/app-service.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: 'myAppServicePlan'
    location: 'EastUS'
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

// Azure Web App Deployment
module webApp './modules/web-app.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: 'myWebApp'
    location: 'EastUS'
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    containerRegistryName: containerRegistry.outputs.loginServer
    containerRegistryImageName: 'myImage'
    containerRegistryImageVersion: 'latest'
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/myImage:latest'
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
