# Azure Key Vault Functions

## 1. Key Rotation Function

Function rotates a vault key by adding a new regenerated key to Key Vault as a new version of the key. It is triggered by a `KeyNearExpiry` event send by azure key vault (by default in `30` days before expiration date). The function requires `ValidityPeriodDays` tag to be defined in vault key metadata, e.g. `ValidityPeriodDays = "180"` which means that the key will expire in `180` days from creation date.

To create a release, merge your changes with `release` branch and use `release.zip` asset in your terraform/azure setup by setting `WEBSITE_RUN_FROM_PACKAGE = uri_to_release_archive` in your `app_settings` of a function app e.g.:
```
resource "azurerm_function_app" "vault_unsealer_function_app" {
(...)
  app_settings = {
    (...)
    WEBSITE_RUN_FROM_PACKAGE = "https://github.com/Chatham/AzureKeyVaultFunctions/releases/download/v20201111.358280023/release.zip"
  }
(...)
}
```
