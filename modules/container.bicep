@description('Name of the Azure Container Registry.')
param name string

@description('Location of the Azure Container Registry.')
param location string = resourceGroup().location

@description('Enable admin user with push/pull permissions to the registry.')
param acrAdminUserEnabled bool = true

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}
#disable-next-line outputs-should-not-contain-secrets
@description('The admin user credentials for the Azure Container Registry.')
output adminCredentials object = acr.listCredentials()

#disable-next-line outputs-should-not-contain-secrets
@description('The username for the Azure Container Registry admin.')
output adminUsername string = acr.listCredentials().username

#disable-next-line outputs-should-not-contain-secrets
@description('The primary admin password for the Azure Container Registry.')
output adminPassword string = acr.listCredentials().passwords[0].value


#disable-next-line outputs-should-not-contain-secrets
@description('The resource ID of the Azure Container Registry.')
output resourceId string = acr.id
output url string = acr.properties.loginServer
