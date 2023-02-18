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
ARG SONAR_SCANNER_VERSION=4.8.0.2856
ARG SONAR_SCANNER_DOWNLOAD_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-windows.zip


ENV SONAR_SCANNER_DOWNLOAD_URL=

SHELL ["powershell", "-Command"]

# Install choco
# RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
#     [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
#     iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
# RUN $ErrorActionPreference = 'Stop' ; \
#     choco install -y python --version 3.11.0 ; \
#     choco install -y 7zip --version 22.1 ; \
#     choco install -y git --version 2.39.2 --params "/GitAndUnixToolsOnPath" ; \
#     choco install -y conan --version 1.58.0 ; \
#     choco install -y ninja --version 1.11.1 ; \
#     choco install -y cmake --version 3.25.2 ; \
#     choco install -y gitlab-runner --version 15.8.0 --params="'/InstallDir=c:\gitlab-runner /Service'"
   
# Install MSVC
# RUN powershell -NoProfile -InputFormat None -Command \
#     choco install -y visualcpp-build-tools --version 15.0.26228.20170424 ; \
#     Write-Host 'Waiting for Visual C++ Build Tools to finish'; \
#     Wait-Process -Name vs_installer

# Install mingw8.1.0
# TODO

# Install sonar-scanner-cli
RUN $ErrorActionPreference = 'Stop' ; \
    wget -Uri $SONAR_SCANNER_DOWNLOAD_URL -OutFile c:\sonar-scanner-cli.zip ; \
    Expand-Archive -Path c:\sonar-scanner-cli.zip -DestinationPath c:\ ; \
    Remove-Item c:\sonar-scanner-cli.zip -Force
