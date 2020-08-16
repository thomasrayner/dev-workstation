<#
.SYNOPSIS
    Creates a new markdown Azure Button for your Github site
.DESCRIPTION
    Creates Azure Button based on the example on https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-azure-button
.EXAMPLE
    PS C:\> New-AzureButton -url <githubrawlink>
#>
function New-AzureButton {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Url
    )
    
    process {
                #escape for formatting
                $uri = [uri]::EscapeDataString($url)
                $start = "https://portal.azure.com/#create/Microsoft.Template/uri/"
                $fullurl = $start + $uri
                $markdown = "[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](" + $fullurl + ")"
                $markdown
        
    }
    
}