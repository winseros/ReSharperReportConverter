# ReSharper CLT report converter

Takes the standard [ReSharper CLT](https://www.jetbrains.com/resharper/download/#section=commandline) output and converts it into a human-readable _HMTL report_ or _console output_.

The package can be used inside docker. See [the example](how-to-docker).

## Generate console output

1) Generate a report file using the standard [ReSharper CLT](https://www.jetbrains.com/resharper/download/#section=commandline) commands, e.g.:
    ```
    inspectCode.exe -o="<path_to_report_xml>" <path_to_solution>
    ```

2) Run the powershell script:
    ```
    write-console.ps1 -ResharperReport <path_to_report_xml> -Colorize -FailOnIssues
    ```

3) See the console output

### Example

```
inspectCode.exe -o=".\example-resharper-output\resharper-output.xml" ..\GitlabTelegramChannel\src\TGramIntegration.sln

write-console.ps1 -ResharperReport .\example-resharper-output\resharper-output.xml -OutputFile .\example-report\report.html
```

### Options
`write-console.ps1` supports the following options

#### ResharperReport
**Type**: string

**Description**: Path to ReSharper CTL output xml file

**Mandatory**: yes

#### Colorize
**Type**: boolean

**Description**: Should the output be colorized

**Default**: false

#### FailOnIssues
**Type**: boolean

**Description**: Should the `1` exit code be returned in case of any issues detected by ReSharper

**Default**: false

## Generate HTML report

1) Generate a report file using the standard [ReSharper CLT](https://www.jetbrains.com/resharper/download/#section=commandline) commands, e.g.:
    ```
    inspectCode.exe -o="<path_to_report_xml>" <path_to_solution>
    ```

2) Run the powershell script:
    ```
    make-html.ps1 -ResharperReport <path_to_report_xml> -OutputFile <path_to_report_html> -FailOnIssues
    ```

3) Use the generated HTML file as desired

### Example

```
inspectCode.exe -o=".\example-resharper-output\resharper-output.xml" ..\GitlabTelegramChannel\src\TGramIntegration.sln

make-html.ps1 -ResharperReport .\example-resharper-output\resharper-output.xml -OutputFile .\example-report\report.html -FailOnIssues
```

### Options
`make-html.ps1` supports the following options

#### ResharperReport
**Type**: string

**Description**: Path to ReSharper CTL output xml file

**Mandatory**: yes

#### OutputFile
**Type**: string

**Description**: Path to the resulting HTML file

**Mandatory**: yes

#### ProjectName
**Type**: string

**Description**: Project name to show in the resulting HTML file

**Mandatory**: no

**Default**: Unknown project

#### UrlFormat
**Type**: string

**Description**: Items in the resulting HTML report are intended to work as hyperlinks and target to files at some source control (BitBucket/GitHub/GitLab). Use this parameter to specify address of your source control. The template strings has the following parameters 
* `{0}` - will be replaced with a file name
* `{1}` - will be replaced with a line number

**Mandatory**: no

**Example**: 
```
-UrlFormat "https://github.com/winseros/GitlabTelegramChannel/tree/v1.0.1/src/{0}#L{1}"
```
**Default**: `{0}#{1}`

#### FailOnIssues
**Type**: boolean

**Description**: Should the `1` exit code be returned in case of any issues detected by ReSharper

**Default**: false