#Usage .tools/pack.ps1 -Version 1.0.0

Param([Parameter(Mandatory)][string]$Version)

$ScriptPath=Split-Path -Parent $MyInvocation.MyCommand.Path
$PackagePath=[System.IO.Path]::Combine($ScriptPath, "..", "__package")
$ArchivePath=Join-Path $PackagePath ("/ReSharperReportConverter-v{0}.zip" -f $Version)

$FilesToPack=@(
    "_Format-Html.ps1",
    "_html_transform.xslt",
    "_Transform-Context.ps1",
    "_Write-Console.ps1",
    "LICENSE",
    "make-html.ps1",
    "README.MD"
    "write-console.ps1"
)

for ($i = 0; $i -lt $FilesToPack.Count; $i++)
{
    $FilesToPack[$i] = [System.IO.Path]::Combine($ScriptPath, "..", $FilesToPack[$i])
}

if (Test-Path $PackagePath)
{
    Remove-Item -Path $PackagePath -Recurse -Force
}
New-Item -ItemType Directory -Path $PackagePath | Out-Null
Compress-Archive -DestinationPath $ArchivePath -Path $FilesToPack -CompressionLevel Optimal