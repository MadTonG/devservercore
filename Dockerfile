FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL description="servercore:ltsc2019 with cdas environment" maintainer="Leo"

# Disable crash dialog for release-mode runtimes
# RUN reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
# RUN reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DontShowUI /t REG_DWORD /d 1 /f

# ARG MINGW_VERSION=8.1.0
# ARG MINGW_ARCH=x86_64
# ARG MINGW_THREADS=posix
# ARG MINGW_EXCEPTION=seh
# ARG MINGW_RT_FILE_SUFFIX=6
# ARG MINGW_BUILD_REVISION=0
# ARG MINGW_PROJECT_URL=https://sourceforge.net/projects/mingw-w64/files
# ARG MINGW_TOOLCHAIN_URL=Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds
# ARG MINGW_DOWNLOAD_URL=${MINGW_PROJECT_URL}/${MINGW_TOOLCHAIN_URL}/${MINGW_VERSION}/threads-${MINGW_THREADS}/${MINGW_EXCEPTION}/x86_64-${MINGW_VERSION}-release-${MINGW_THREADS}-${MINGW_EXCEPTION}-rt_v${MINGW_RT_FILE_SUFFIX}-rev${MINGW_BUILD_REVISION}.7z
# ARG SONAR_SCANNER_VERSION=
# ARG SONAR_SCANNER_DOWNLOAD_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-windows.zip


# ENV SONAR_SCANNER_DOWNLOAD_URL
# ENV SONAR_SCANNER_VERSION 4.8.0.2856
# ENV SONAR_SCANNER_DOWNLOAD_URL "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-windows.zip"


# Install choco
# RUN powershell.exe -Command \
# 	Set-ExecutionPolicy Bypass -Scope Process -Force; \
# 	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
# 	iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
# RUN $ErrorActionPreference = 'Stop' ; \
#     choco install -y git --version 2.39.2 --params "/GitAndUnixToolsOnPath" ;

	
RUN powershell.exe -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    wget https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe -OutFile c:\python-3.11.2-amd64.exe ; \
    Start-Process c:\python-3.11.2-amd64.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
    Remove-Item c:\python-3.11.2-amd64.exe -Force

RUN ["pip", "install", "conan==1.59.0", "ninja==1.11.1", "cmake==3.25.2", "clang-fomat", "clang-tidy"]
   
# Install MSVC
# RUN powershell -NoProfile -InputFormat None -Command \
#     choco install -y visualcpp-build-tools --version 15.0.26228.20170424 ; \
#     Write-Host 'Waiting for Visual C++ Build Tools to finish'; \
#     Wait-Process -Name vs_installer

# 7zip
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	wget https://www.7-zip.org/a/7z2201-x64.exe -OutFile c:\7z2201-x64.exe ; \
	Start-Process c:\7z2201-x64.exe -ArgumentList '/S /D="c:\7-Zip"' -Wait ; \
	setx /M Path "%path%;c:\7-Zip" ; \
	Remove-Item c:\7z2201-x64.exe -Force

# Install mingw8.1.0
RUN powershell -Commnad \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	wget "https://sourceforge.net/projects/mingw-w64/files/Toolchains targetting Win64/Personal Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z" -OutFile c:\mingw81.7z ; \
	Start-Process 7z.exe x c:\mingw81.7z c:\ ; \
	setx /M Path "%path%;c:\mingw64\bin" ; \
	Remove-Item c:\mingw81.7z -Force

# Install sonar-scanner-cli
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-windows.zip -OutFile c:\sonar-scanner-cli.zip ; \
	Expand-Archive -Path c:\sonar-scanner-cli.zip -DestinationPath c:\sonar-scanner-cli ; \
	setx /M Path "%path%;c:\sonar-scanner-cli\bin" ; \
	Remove-Item c:\sonar-scanner-cli.zip -Force
	
RUN powershell -Command \
	git.exe --version
	
CMD ["g++.exe --version"]
