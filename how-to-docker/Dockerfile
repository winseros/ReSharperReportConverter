# An example of how the ResharperReportConverter might be used with Docker
# Build the docker image: docker build . -t resharper-report
# Ensure the image doesn't build by-default due to the issues found
# This behavior can be controlled by the "fail_on_issues" arg - see below

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster

# the required stuff; It might take time to download
# so I expect you to prepack it into a separate image
# also be aware the URLs might have changed since the time I wrote this doc
ADD https://github.com/winseros/ReSharperReportConverter/releases/download/v1.0.0/ReSharperReportConverter-v1.0.0.tar.gz /resharper-report/
ADD https://github.com/PowerShell/PowerShell/releases/download/v7.0.1/powershell-7.0.1-linux-x64.tar.gz /powershell/
ADD https://download.jetbrains.com/resharper/ReSharperUltimate.2020.1.3/JetBrains.ReSharper.CommandLineTools.Unix.2020.1.3.tar.gz /resharper-clt/
RUN tar -xzf /resharper-report/ReSharperReportConverter-v1.0.0.tar.gz -C /resharper-report/ \
    && tar -xzf /powershell/powershell-7.0.1-linux-x64.tar.gz -C /powershell/ \
    && tar -xzf /resharper-clt/JetBrains.ReSharper.CommandLineTools.Unix.2020.1.3.tar.gz -C /resharper-clt/


WORKDIR /src
COPY Solution1.sln Solution1.sln.DotSettings ClassLibrary1.csproj ./
RUN dotnet restore Solution1.sln
COPY ./*.cs ./

ARG fail_on_issues="\$True" 
# or "\$False"
# to pass it from the command line use the syntax:
# --build-arg fail_on-issues="$True" 
# (or "$False")

#here we run ReSharper and process its output
RUN /resharper-clt/inspectcode.sh -o=report.xml Solution1.sln \
    && /powershell/pwsh \
        -f /resharper-report/write-console.ps1 \
        -ResharperReport ./report.xml \
        -Colorize \
        -FailOnIssues:$fail_on_issues
