@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable admin user that has push/pull permission to the registry.')
param acrAdminUserEnabled bool = true
@description('The name of the Docker image in the registry.')
param containerRegistryImageName string

@description('The version of the Docker image.')
param containerRegistryImageVersion string


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

@description('The login server URL of the Azure Container Registry.')
output loginServer string = containerRegistry.properties.loginServer

@description('The admin username for the ACR (if admin user is enabled).')
output adminUsername string = acrAdminUserEnabled ? listCredentials(containerRegistry.id, '2023-06-01-preview').username : ''

@description('The admin password for the ACR (if admin user is enabled).')
output adminPassword string = acrAdminUserEnabled ? listCredentials(containerRegistry.id, '2023-06-01-preview').passwords[0].value : ''
