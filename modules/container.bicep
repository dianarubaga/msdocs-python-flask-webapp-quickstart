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
output adminCredentials object = acr.listCredentials()

#disable-next-line outputs-should-not-contain-secrets
output adminUsername string = acr.listCredentials().username

#disable-next-line outputs-should-not-contain-secrets
output adminPassword string = acr.listCredentials().passwords[0].value



