Param([Parameter(Mandatory)][string]$ProjectName,
      [Parameter(Mandatory)][string]$ContextFile,
      [Parameter(Mandatory)][string]$ReportFile)

$Context = New-Object System.Xml.XmlDocument
$Context.Load($ContextFile)

$Args = New-Object System.Xml.Xsl.XsltArgumentList
$Args.AddParam("projectName", $null, $ProjectName)
$Args.AddParam("currentDate", $null, (Get-Date | Out-String))

$Xsl = New-Object System.Xml.Xsl.XslCompiledTransform
$Xsl.Load((Join-Path -Path $PSScriptRoot -ChildPath _html_transform.xslt))

New-Item -Type File -Path $ReportFile -Force | Out-Null
$Stream = [System.IO.File]::Open((Resolve-Path $ReportFile), [System.IO.FileMode]::Open, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
$Xsl.Transform($Context, $Args, $Stream)

$Stream.Flush()
$Stream.Dispose()