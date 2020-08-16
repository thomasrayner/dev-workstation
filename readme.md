# Quick and Dirty Dev Workstations in Azure (customized for me)

It's quick and dirty by design. Lots of flexibility, and not a lot of dependencies :) 

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fudubnate%2Fdev-workstation%2Fmaster%2Fazuredeploy.json)

Post-Deployment Config Script: [bit.ly/nate-dev](https://bit.ly/nate-dev)


Then run `iex '$((iwr bit.ly/nate-dev -usebasicparsing).Content) | out-file c:\Initialize.ps1; c:\initialize.ps1 -UACNoConsent'` from an administrative PowerShell console (substitute -All for whichever flag you want: All, Office, PowerPointViewer, VisualStudio, Help, Remoting).


## Behind the Scenes

- How to create an Azure Button - https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-azure-button
