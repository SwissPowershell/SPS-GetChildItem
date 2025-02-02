Import-Module "$($PSScriptRoot)\SPS-GetChildItem.psd1" -Force
# Set the most constrained mode
Set-StrictMode -Version Latest
# Set the error preference
$ErrorActionPreference = 'Stop'
# Set the verbose preference in order to get some insights
$VerbosePreference = 'Continue'
$DebugStart = Get-Date

############################
# Test your functions here #
############################

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

$Path = 'C:\Windows'

$SPSMeasureQuick = Measure-Command -Expression {
    $ResultSPSQuick = Get-SPSChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue
    $Null = $ResultSPSQuick
}

$SPSMeasure = Measure-Command -Expression {
    $ResultSPS = Get-SPSChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -AsFileInfo
    $Null = $ResultSPS
}
$StandardMeasure = Measure-Command -Expression {
    $ResultNative = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -File
    $Null = $ResultNative
}

Write-Host "Performance while getting files only"
Write-Host "SPS-GetChildItem (as string): $($SPSMeasureQuick.TotalSeconds) s - Count : $($ResultSPSQuick.Count)"
Write-Host "SPS-GetChildItem : $($SPSMeasure.TotalSeconds) s - Count : $($ResultSPS.Count)"
Write-Host "Standard Get-ChildItem : $($StandardMeasure.TotalSeconds) s - Count : $($ResultNative.Count)"

# git add --all;Git commit -a -am 'Initial Commit';Git push

##################################
# End of the tests show metrics #
##################################

Write-Host '------------------- Ending script -------------------' -ForegroundColor Yellow
$TimeSpentInDebugScript = New-TimeSpan -Start $DebugStart -Verbose:$False -ErrorAction SilentlyContinue
$TimeUnits = [ordered]@{TotalDays = "$($TimeSpentInDebugScript.TotalDays) D.";TotalHours = "$($TimeSpentInDebugScript.TotalHours) h.";TotalMinutes = "$($TimeSpentInDebugScript.TotalMinutes) min.";TotalSeconds = "$($TimeSpentInDebugScript.TotalSeconds) s.";TotalMilliseconds = "$($TimeSpentInDebugScript.TotalMilliseconds) ms."}
foreach ($Unit in $TimeUnits.GetEnumerator()) {if ($TimeSpentInDebugScript.$($Unit.Key) -gt 1) {$TimeSpentString = $Unit.Value;break}}
if (-not $TimeSpentString) {$TimeSpentString = "$($TimeSpentInDebugScript.Ticks) Ticks"}
Write-Host 'Ending : ' -ForegroundColor Yellow -NoNewLine
Write-Host $($MyInvocation.MyCommand) -ForegroundColor Magenta -NoNewLine
Write-Host ' - TimeSpent : ' -ForegroundColor Yellow -NoNewLine
Write-Host $TimeSpentString -ForegroundColor Magenta
