$global:forePromptColor = 0
$global:leftArrow = [char]0xe0b2
$global:rightArrow = [char]0xe0b0
$global:esc = "$([char]27)"
$global:fore = "$esc[38;5"
$global:back = "$esc[48;5"
$global:prompt = ''


[System.Collections.Generic.List[ScriptBlock]]$global:PromptRight = @(
    # right aligned
    { "$fore;${errorColor}m{0}" -f $leftArrow }
    { "$fore;${forePromptColor}m$back;${errorColor}m{0}" -f $(if (@(get-history).Count -gt 0) {(get-history)[-1] | % { "{0:c}" -f (new-timespan $_.StartExecutionTime $_.EndExecutionTime)}}else {'00:00:00.0000000'}) }
    
    { "$fore;7m$back;${errorColor}m{0}" -f $leftArrow }
    { "$fore;0m$back;7m{0}" -f $(get-date -format "hh:mm:ss tt") }
)

[System.Collections.Generic.List[ScriptBlock]]$global:PromptLeft = @(
    # left aligned
    { "$fore;${forePromptColor}m$back;${global:platformColor}m{0}" -f $('{0:d4}' -f $MyInvocation.HistoryId) }
    { "$back;22m$fore;${global:platformColor}m{0}" -f $rightArrow }
    
    { "$back;22m$fore;${forePromptColor}m{0}" -f $(if ($pushd = (Get-Location -Stack).count) { "$([char]187)" + $pushd }) }
    { "$fore;22m$back;5m{0}" -f $rightArrow }
    
    { "$back;5m$fore;${forePromptColor}m{0}" -f $($pwd.Drive.Name) }
    { "$back;14m$fore;5m{0}" -f $rightArrow }
    
    { "$back;14m$fore;${forePromptColor}m{0}$esc[0m" -f $(Split-Path $pwd -leaf) }
)
function global:prompt {
    $global:errorColor = if ($?) {22} else {1}
    $global:platformColor = if ($isWindows) {11} else {117}
        
    $gitTest = $(git config -l) -match 'branch\.'
    if (-not [string]::IsNullOrEmpty($gitTest)) {
        $branch = git symbolic-ref --short -q HEAD
        $aheadbehind = git status -sb
        $distance = ''
    
        if (-not [string]::IsNullOrEmpty($(git diff --staged))) { $branchbg = 3 }
        else { $branchbg = 5 }
    
        if (-not [string]::IsNullOrEmpty($(git status -s))) { $arrowfg = 3 }
        else { $arrowfg = 5 }
    
        if ($aheadbehind -match '\[\w+.*\w+\]$') {
            $ahead = [regex]::matches($aheadbehind, '(?<=ahead\s)\d+').value
            $behind = [regex]::matches($aheadbehind, '(?<=behind\s)\d+').value
    
            $distance = "$back;15m$fore;${arrowfg}m{0}$esc[0m" -f $rightArrow
            if ($ahead) {$distance += "$back;15m$fore;${forePromptColor}m{0}$esc[0m" -f "a$ahead"}
            if ($behind) {$distance += "$back;15m$fore;${forePromptColor}m{0}$esc[0m" -f "b$behind"}
            $distance += "$fore;15m{0}$esc[0m" -f $rightArrow
        }
        else {
            $distance = "$fore;${arrowfg}m{0}$esc[0m" -f $rightArrow
        }
    
        [System.Collections.Generic.List[ScriptBlock]]$gitPrompt = @(
            { "$back;${branchbg}m$fore;14m{0}$esc[0m" -f $rightArrow }
            { "$back;${branchbg}m$fore;${forePromptColor}m{0}$esc[0m" -f $branch }
            { "{0}$esc[0m" -f $distance }
        )
        $leftSide = -join @($global:PromptLeft + $gitPrompt + {" "}).Invoke()
    }
    else {
        $leftSide = -join @($global:PromptLeft + { "$fore;14m{0}$esc[0m" -f $rightArrow } + {" "}).Invoke()
    }
    
    $rightSide = -join ($global:promptRight).Invoke()
    $offset = $global:host.UI.RawUI.BufferSize.Width - 28
    $prompt = -join @($leftSide, "$esc[${offset}G", $rightSide, "$esc[0m" + "`n`r`> ")
    $prompt
}


# Set this alias every time PowerShell launches so I stop mistyping code-insiders
Set-Alias code code-insiders

Set-PSReadLineOption -PredictionSource History
