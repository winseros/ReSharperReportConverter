Param([Parameter(Mandatory)][string]$ResharperReport,
[switch]$Colorize = $False,
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
        Write-Host ("InspectCode reported issues in codebase")
        .\_Transform-Context.ps1 -Xml $ReportContext -DumpTo $ContextFile -UrlFormat "{0}#{1}"
        .\_Write-Console.ps1 -ContextFile (Get-Content $ContextFile) -Colorize $Colorize
    } finally{
        if (Test-Path $ContextFile) {
            Remove-Item -Path $ContextFile -Force
        }
    }
} else {
    Write-Host "ReSharper detected no issues in the codebase"
}

if (-not $FailOnIssues){
    $HasIssues = 0
}

exit $HasIssues
