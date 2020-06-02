Param(
    [Parameter(Mandatory)][xml]$ContextFile,
    [bool]$Colorize)

$ColorMap = @{
    "Error" = "DarkRed";
    "Warning" = "DarkYellow";
    "Suggestion" = "DarkCyan";
    "Hint" = "DarkGreen";
    "Info" = "Cyan";
}

foreach ($Project in $ContextFile.Report.ChildNodes)
{
    Write-Host ("Project: {0}" -f $Project.Name);
    foreach ($File in $Project.ChildNodes)
    {
        Write-Host ("  File: {0}" -f $File.Name)
        foreach ($Line in $File.ChildNodes)
        {
            if ($Colorize)
            {
                Write-Host "    " -NoNewline
                Write-Host $Line.Severity -ForegroundColor ($ColorMap[$Line.Severity]) -Nonewline
                Write-Host (", Line {0}, {1}" -f $Line.Number, $Line.Message)
            }
            else
            {
                Write-Host ("    {0}, Line {1}, {2}" -f $Line.Severity, $Line.Number, $Line.Message)
            }
        }
    }
}