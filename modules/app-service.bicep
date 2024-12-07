@description('The name of the App Service Plan.')
param name string

@description('The location of the App Service Plan.')
param location string = resourceGroup().location

@description('Specifies the pricing tier and compute resources for the App Service Plan.')
param sku object

@description('The kind of App Service Plan (e.g., Linux).')
param kind string = 'Linux'

@description('Reserved setting for Linux hosting plans.')
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: reserved
  }
}

@description('The resource ID of the App Service Plan.')
output resourceId string = appServicePlan.id
