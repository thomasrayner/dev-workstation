# Quick and Dirty Dev Workstations in Azure

It's quick and dirty by design. Lots of flexibility, and not a lot of dependencies :)

[![Deploy](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fthomasrayner%2Fdev-workstation%2Fmaster%2Fazuredeploy.json)

Post-Deployment Config Script: [bit.ly/tfr-dev](http://bit.ly/tfr-dev)

Then run `iex '$((iwr bit.ly/tfr-dev -usebasicparsing).Content) | out-file c:\Initialize.ps1; c:\initialize.ps1 -UACNoConsent'` from an administrative PowerShell console.

## Update: April 2021

There's a great chance that there is a better Azure SKU to use, but I don't actually use the Azure deployment part of this a lot. Mostly I'm just running the script to configure a new laptop or something. Your milage may vary! :)
