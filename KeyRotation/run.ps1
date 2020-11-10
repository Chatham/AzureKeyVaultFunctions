param($eventGridEvent, $TriggerMetadata)

# By a key rotation we mean creating a new version of the key
function RotateKey($vaultName, $keyName) {
    # Retrieve Key
    $key = Get-AzKeyVaultKey -VaultName $vaultName -Name $keyName
    $version = $key.Version.ToString()
    Write-Host "Key retrieved. Version: $version"

    $validityPeriodDays = $key.Tags["ValidityPeriodDays"]
    
    Write-Host "Key info retrieved"
    Write-Host "Validity period: $validityPeriodDays"

    # Add a new key to Key Vault
    $newKeyVersionTags = @{}
    $newKeyVersionTags.ValidityPeriodDays = $validityPeriodDays

    $expiryDate = (Get-Date).AddDays([int] $validityPeriodDays).ToUniversalTime()
    $newKey = Add-AzKeyVaultKey -VaultName $vaultName -Name $keyName -Tag $newKeyVersionTags -Expires $expiryDate -Destination Software
    $newVersion = $newKey.Version.ToString()
    Write-Host "New key added to Key Vault. Key Version: $newVersion"
    # $newKey | ConvertTo-Json | Write-Host

    # TODO clean expired keys - not possible
}

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | ConvertTo-Json | Write-Host

$keyName = $eventGridEvent.subject
$vaultName = $eventGridEvent.data.VaultName
Write-Host "Key vault name: $vaultName"
Write-Host "Key name: $keyName"

# Rotate key
Write-Host "Rotation started"
RotateKey $vaultName $keyName
Write-Host "Key rotated successfully"
