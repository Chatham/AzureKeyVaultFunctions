# Azure Key Vault Functions

## Key Rotation Function

Function rotates a vault key by adding a new regenerated key to Key Vault as a new version of the key. It is triggered by a KeyNearExpiry event send by azure key vault (by default in 30 days before expiration date). The function requires ValidityPeriodDays tag to be defined in vault key metadata, e.g. ValidityPeriodDays = 180 which means that the key will expire in 180 days from creation date.
