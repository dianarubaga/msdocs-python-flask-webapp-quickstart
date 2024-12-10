metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the app service plan.')
@minLength(1)
@maxLength(60)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('SKU configuration for the App Service Plan.')
param sku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

@description('Specifies the kind of App Service Plan. For Linux, use "Linux".')
param kind string = 'Linux'

@description('Specifies whether the App Service Plan is reserved for Linux. Should be set to true.')
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: reserved
  }
}
// idk
@description('The resource ID of the App Service Plan.')
output resourceId string = appServicePlan.id

