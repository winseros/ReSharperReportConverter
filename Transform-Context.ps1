Param([Parameter(Mandatory)][xml]$Xml, 
      [Parameter(Mandatory)][string]$DumpTo,
      [string]$UrlFormat)

function Get-Severity([xml]$Xml, [string]$Key){
    $IssueType = $Xml.DocumentElement["IssueTypes"].ChildNodes | Where-Object {$_.Attributes["Id"].Value -eq $Key}
    return $IssueType.Severity
}

$Output = New-Object System.Xml.XmlDocument
$Output.AppendChild($Output.CreateXmlDeclaration("1.0", "utf-8", $null)) | Out-Null

$Report = $Output.CreateElement("Report")
$Output.AppendChild($Report) | Out-Null

$Xml.DocumentElement["Issues"].ChildNodes | ForEach-Object {
    $Project = $Output.CreateElement("Project")
    $Project.SetAttribute("Name", $_.Name)
    $Report.AppendChild($Project) | Out-Null
    $File = $null
    $_.ChildNodes | ForEach-Object {
        if ($File -eq $null -or $File.Name -ne $_.File)
        {
            $File = $Output.CreateElement("File")
            $File.SetAttribute("Name", $_.File)
            $Project.AppendChild($File) | Out-Null
        }
        $Line = $Output.CreateElement("Line")
        $Number = if ($_.Line -eq $null) {1} else {$_.Line}
        $Line.SetAttribute("Number", $Number)
        $Line.SetAttribute("Message", $_.Message)
        $Line.SetAttribute("Severity", (Get-Severity -Xml $Xml -Key $_.TypeId))
        if (-not [String]::IsNullOrEmpty($UrlFormat)) {
            $Line.SetAttribute("Href", ($UrlFormat -f $File.Name, $Number))
        }
        $File.AppendChild($Line) | Out-Null
    }
}

$Output.Save($DumpTo)
exit 0