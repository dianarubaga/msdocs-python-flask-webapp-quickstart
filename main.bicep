param appServicePlanName string
param kind string
param location string = resourceGroup().location
param sku object
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'latest'
param keyVaultName string
param webAppName string

// hello
// var adminUsernameSecretName = 'acrAdminUsername'
// var adminPasswordSecretName = 'acrAdminPassword'
param adminUsernameSecretName string 
param adminPasswordSecretName string

module keyVault 'modules/keyvault.bicep' = {
  name: keyVaultName
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true
    roleAssignments: [
      {
        principalId: '7200f83e-ec45-4915-8c52-fb94147cfe5a'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // Group.
        roleDefinitionIdOrName: 'Key Vault Administrator'
        principalType: 'Group'
      }
    ]
  }
}

module containerRegistry 'modules/contreg.bicep' = {
  name: '${containerRegistryName}-module'
  params: {
    name: containerRegistryName
    location: location
    keyVaultResourceId: keyVault.outputs.resourceId
    adminUsernameSecretName: adminUsernameSecretName
    adminPasswordSecretName: adminPasswordSecretName
  }
  dependsOn: [
    keyVault 
  ]  
}

module appServicePlan 'modules/asp.bicep' = {
  name: '${appServicePlanName}-module'
  params: {
    name: appServicePlanName
    kind: kind
    location: location
    sku: sku
  }
}

resource keyVaultReference 'Microsoft.KeyVault/vaults@2022-07-01'existing = {
  name: keyVaultName
}

module webApp 'modules/web-app.bicep' = {
  name: webAppName
  params: {
    name: webAppName
    location: location
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    containerRegistryName: containerRegistryName
    containerRegistryImageName: containerRegistryImageName
    containerRegistryImageVersion: containerRegistryImageVersion
    dockerRegistryServerPassword: keyVaultReference.getSecret(adminPasswordSecretName)
    dockerRegistryServerUserName: keyVaultReference.getSecret(adminUsernameSecretName)
  
  }
  dependsOn: [
    containerRegistry
    keyVault
    ]
}
