$KeyVault = Get-AzKeyVault -VaultName NVault2020 -ResourceGroupName Vault 

Set-AzVMDiskEncryptionExtension -ResourceGroupName "2020-08-18-Nate" -VMName "nate-dev" -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId