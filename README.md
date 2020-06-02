# ReSharper CLT report converter

Converts the standard [ReSharper CLT](https://www.jetbrains.com/resharper/download/#section=resharper-clt) xml report into human-readable HTML format. 

## Usage
1) Generate a report file using the standard ReSharper CLT commands, e.g.:

```
inspectCode.exe -o="<path_to_report_xml>" <path_to_solution>
```

2) Run the powershell script:
```
make-html.ps1 -ResharperReport <path_to_report_xml> -OutputFile <path_to_report_html>
```

3) Use the generated HTML file as desired

## Example

```
inspectCode.exe -o=".\example-resharper-output\resharper-output.xml" ..\GitlabTelegramChannel\src\TGramIntegration.sln

make-html.ps1 -ResharperReport .\example-resharper-output\resharper-output.xml -OutputFile .\example-report\report.html
```

## Options
`make-html.ps1` supports the following options

### ResharperReport
**Type**: string

**Description**: Path to ReSharper CTL output xml file

**Mandatory**: yes

### OutputFile
**Type**: string

**Description**: Path to the resulting HTML file

**Mandatory**: yes

### ProjectName
**Type**: string

**Description**: Project name to show in the resulting HTML file

**Mandatory**: no

**Default**: Unknown project

### UrlFormat
**Type**: string

**Description**: Items in the resulting HTML report are intended to work as hyperlinks and target to files at some source control (BitBucket/GitHub/GitLab). Use this parameter to specify address of your source control. The template strings has the following parameters 
* `{0}` - would be replaced with a file name
* `{1}` - would be replaced with a line number

**Mandatory**: no

**Example**: 
```
-UrlFormat "https://github.com/winseros/GitlabTelegramChannel/tree/v1.0.1/src/{0}#L{1}"
```
**Default**: `{0}#{1}`

### FailOnIssues
**Type**: Boolean

**Description**: Should the `1` exit code be returned in case of any issues detected by ReSharper

**Default**: false