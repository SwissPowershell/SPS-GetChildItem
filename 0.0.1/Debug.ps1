$PSD1File = Get-ChildItem -Path "$($PSScriptRoot)\*.psd1" -ErrorAction SilentlyContinue
Import-Module $PSD1File.FullName -Force

# Set the most constrained mode
Set-StrictMode -Version Latest

# Set the error preference
$ErrorActionPreference = 'Stop'

# Set the verbose preference in order to get some insights
$VerbosePreference = 'Continue'

# Set the stopwatch
$DebugStopWatch = [System.Diagnostics.Stopwatch]::new()
$DebugStopWatch.Start()

# Set the Verbose color as something different than the warning color (yellow)
if (Get-Variable -Name PSStyle -ErrorAction SilentlyContinue) {
    $PSStyle.Formatting.Verbose = $PSStyle.Foreground.BrightCyan
}Else{
    $Host.PrivateData.VerboseForegroundColor = 'Cyan'
}

############################
# Test your functions here #
############################

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

$Path = 'C:\'
$StopWatch = [System.Diagnostics.Stopwatch]::new()

$StopWatch.Start()
$ResultSPSQuick = Get-SPSChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue
$StopWatch.Stop()
$SPSMeasureQuick = $StopWatch.Elapsed

$StopWatch.Restart()
$ResultSPS = Get-SPSChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -AsFileInfo
$StopWatch.Stop()
$SPSMeasure = $StopWatch.Elapsed

$StopWatch.Restart()
$ResultNative = Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue -File
$StopWatch.Stop()
$NativeMeasure = $StopWatch.Elapsed

Write-Host "SPS-GetChildItem (as string): " -NoNewLine -ForegroundColor Blue
Write-Host "$($SPSMeasureQuick.TotalSeconds) s - Count : $($ResultSPSQuick.Count)" -ForegroundColor Green
Write-Host "SPS-GetChildItem : " -NoNewLine -ForegroundColor Blue
Write-Host "$($SPSMeasure.TotalSeconds) s - Count : $($ResultSPS.Count)" -ForegroundColor Green
Write-Host "Standard Get-ChildItem : " -NoNewLine -ForegroundColor Blue
Write-Host "$($NativeMeasure.TotalSeconds) s - Count : $($ResultNative.Count)" -ForegroundColor Green
Write-Host ''
Write-Host "Performance gain in percent (as string) : " -NoNewLine -ForegroundColor Blue
Write-Host "$([math]::Round((($NativeMeasure.TotalSeconds - $SPSMeasureQuick.TotalSeconds) / $NativeMeasure.TotalSeconds) * 100, 2)) %" -ForegroundColor Green
Write-Host "Performance gain in percent : " -NoNewLine -ForegroundColor Blue
Write-Host "$([math]::Round((($NativeMeasure.TotalSeconds - $SPSMeasure.TotalSeconds) / $NativeMeasure.TotalSeconds) * 100, 2)) %" -ForegroundColor Green

# git add --all;Git commit -a -am 'Initial Commit';Git push

##################################
# End of the tests show metrics #
##################################
Write-Host '------------------- Ending script -------------------' -ForegroundColor Yellow
$DebugStopWatch.Stop()
$TimeSpentInDebugScript = $DebugStopWatch.Elapsed
$TimeUnits = [ordered]@{TotalDays = "$($TimeSpentInDebugScript.TotalDays) D.";TotalHours = "$($TimeSpentInDebugScript.TotalHours) h.";TotalMinutes = "$($TimeSpentInDebugScript.TotalMinutes) min.";TotalSeconds = "$($TimeSpentInDebugScript.TotalSeconds) s.";TotalMilliseconds = "$($TimeSpentInDebugScript.TotalMilliseconds) ms."}
foreach ($Unit in $TimeUnits.GetEnumerator()) {if ($TimeSpentInDebugScript.$($Unit.Key) -gt 1) {$TimeSpentString = $Unit.Value;break}}
if (-not $TimeSpentString) {$TimeSpentString = "$($TimeSpentInDebugScript.Ticks) Ticks"}
Write-Host 'Ending : ' -ForegroundColor Yellow -NoNewLine
Write-Host $($MyInvocation.MyCommand) -ForegroundColor Magenta -NoNewLine
Write-Host ' - TimeSpent : ' -ForegroundColor Yellow -NoNewLine
Write-Host $TimeSpentString -ForegroundColor Magenta
