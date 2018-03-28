# Quick and Dirty Dev Workstations in Azure

It's quick and dirty by design. Lots of flexibility, and not a lot of dependencies :) 

[![Deploy](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FThmsRynr%2Fdev-workstation%2Fmaster%2Fazuredeploy.json)

Post-Deployment Config Script: [bit.ly/tfr-dev](http://bit.ly/tfr-dev)
Then run `iex "$((iwr bit.ly/tfr-dev -usebasicparsing).Content) | out-file c:\Initialize.ps1; c:\initialize.ps1 -All"` from an administrative PowerShell console (substitute -All for whichever flag you want: All, Office, PowerPointViewer, VisualStudio, Help, Remoting).
