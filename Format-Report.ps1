Param([Parameter(Mandatory)][string]$ProjectName,
      [Parameter(Mandatory)][string]$ContextFile,
      [Parameter(Mandatory)][string]$ReportFile)


$Context = New-Object System.Xml.XmlDocument
$Context.Load($ContextFile)

$Args = New-Object System.Xml.Xsl.XsltArgumentList
$Args.AddParam("projectName", $null, $ProjectName)
$Args.AddParam("currentDate", $null, (Get-Date | Out-String))

$Xsl = New-Object System.Xml.Xsl.XslCompiledTransform
$Xsl.Load((Join-Path -Path $PSScriptRoot -ChildPath transform.xslt))

$Stream = [System.IO.File]::Open($ReportFile, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::Read)
$Xsl.Transform($Context, $Args, $Stream)

$Stream.Flush()
$Stream.Dispose()