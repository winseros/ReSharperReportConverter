Param([Parameter(Mandatory)][string]$ResharperReport,
[Parameter(Mandatory)][string]$OutputFile,
[string]$ProjectName = "Unknown project",
[string]$UrlFormat = "{0}#{1}",
[switch]$FailOnIssues = $False)

if (-not (Test-Path $ResharperReport)) {
    Write-Host ("Could not find file: '{0}'" -f $ResharperReport)
    exit 1
}

function Analyze-Report([xml]$Xml) {
    $HasIssues = $Xml.DocumentElement["Issues"].ChildNodes.Count -ne 0
    $ExitCode = if ($HasIssues) {1} else {0}
    return $ExitCode
}

$ContextFile = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
$ReportContext = Get-Content $ResharperReport

$HasIssues = Analyze-Report -Xml $ReportContext
if ($HasIssues -gt 0) {
    try {
        Write-Host ("InspectCode reported issues in codebase, see '{0}'" -f $OutputFile)
        Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
        .\_Transform-Context.ps1 -Xml $ReportContext -DumpTo $ContextFile -UrlFormat $UrlFormat
        .\_Format-Html.ps1 -ProjectName $ProjectName -ContextFile $ContextFile -ReportFile $OutputFile
    } finally{
        if (Test-Path $ContextFile) {
            Remove-Item -Path $ContextFile -Force
        }
        Pop-Location
    }
} else {
    Write-Host "ReSharper detected no issues in the codebase"
}

if (-not $FailOnIssues){
    $HasIssues = 0
}

exit $HasIssues
