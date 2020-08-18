$locName = "WestUS2"
$pubName = "MicrosoftWindowsDesktop"
$offerName = "Windows-10"
$SKUs = Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select Skus
$skuName = "19h2-pro-g2"
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version
$version = "19041.450.2008080726"