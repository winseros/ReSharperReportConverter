Param(
    [Parameter(Mandatory)][string]$ProjectName,
    [Parameter(Mandatory)][string]$Sln,
    [string]$OutputDirectory = (Get-Location),
    [string]$Report = (Join-Path -Path $OutputDirectory -ChildPath "report.html"),
    [string]$UrlFormat
)

function Analyze-Report([xml]$Xml) {
    $HasIssues = $Xml.DocumentElement["Issues"].ChildNodes.Count -ne 0
    $ExitCode = if ($HasIssues) {1} else {0}
    return $ExitCode
}

$XmlFileName = Join-Path -Path $OutputDirectory -ChildPath "report.xml"
$ContextFileName = Join-Path -Path $OutputDirectory -ChildPath "context.xml"

$Process = Start-Process "inspectcode.exe" -ArgumentList ("--output={0}" -f $XmlFileName), "--swea", $Sln -NoNewWindow -PassThru -Wait
if ($Process.ExitCode -ne 0) {
    Write-Host "Error: InspectCode failed to run"
    exit $Process.ExitCode
}
if (-not $(Get-ChildItem $XmlFileName).Exists) {
    Write-Host ("Error: For some reason the InspectCode report was not found at '{0}'. Please check InspectCode has generated it." -f $XmlFileName)
    exit 1
}

$Xml = Get-Content -Path $XmlFileName
$HasIssues = Analyze-Report -Xml $Xml
if ($HasIssues -gt 0) {
    Write-Host ("InspectCode reported issues in codebase, see '{0}'" -f $Report)
    .\Transform-Context.ps1 -Xml $Xml -DumpTo $ContextFileName -UrlFormat $UrlFormat
    .\Format-Report.ps1 -ProjectName $ProjectName -ContextFile $ContextFileName -ReportFile $Report
}
exit $HasIssues