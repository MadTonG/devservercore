FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL description="mingw-builds-x.y.z" maintainer="Leo"

ARG MINGW_DOWNLOAD_URL=https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z

SHELL ["powershell", "-Command"]

RUN $ErrorActionPreference = 'Stop'; \
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted ; \
    Install-Module -Name 7Zip4Powershell ;
