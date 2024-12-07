// Azure Container Registry Deployment
module containerRegistry './modules/cont.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    name: 'myContainerRegistry' // Replace with your registry name
    location: 'EastUS' // Replace with your desired location
    acrAdminUserEnabled: true // Enable admin user
  }
}


// Azure App Service Plan Deployment
module appServicePlan './modules/app-service.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: 'myAppServicePlan' // Replace with your App Service Plan name
    location: 'EastUS' // Replace with your desired location
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
    name: 'myWebApp' // Replace with your Web App name
    location: 'EastUS' // Replace with your desired location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.resourceId // Link to App Service Plan
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/myImage:latest' // Replace 'myImage' with your actual image name
      appCommandLine: '' // Optional
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: containerRegistry.outputs.loginServer
      DOCKER_REGISTRY_SERVER_USERNAME: containerRegistry.outputs.adminUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: containerRegistry.outputs.adminPassword
    }
    containerRegistryName: containerRegistry.outputs.loginServer // Provide the registry name from outputs
    containerRegistryImageName: 'myImage' // Replace with your image name
    containerRegistryImageVersion: 'latest' // Replace with your image version
  }
}



