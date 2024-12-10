param containerRegistryName string
param location string = resourceGroup().location
param acrAdminUserEnabled bool = true
param appServicePlanName string 
param webAppName string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'latest'


module acr 'modules/container.bicep' = {
  name: 'acrDeployment'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
  }
}

module appServicePlan './modules/appplan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
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

module webapp './modules/webapp.bicep' = {
  name: webAppName
  params: {
    webAppName: webAppName
    location: location
    appServicePlanId: appServicePlan.outputs.resourceId
    containerRegistryName: containerRegistryName
    containerRegistryImageName: containerRegistryImageName
    containerRegistryImageVersion: containerRegistryImageVersion
    containerRegistryUsername: acr.outputs.adminUsername
    containerRegistryPassword: acr.outputs.adminPassword
  }
}

