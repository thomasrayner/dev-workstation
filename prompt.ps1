#requires -Modules posh-git, oh-my-posh

Set-Alias code code-insiders
Set-PoshPrompt -Theme $home\ps\thomasrayner.json
Set-PSReadLineOption -PredictionSource History
