# 基于 Windows Serve Core 镜像
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# 维护信息
LABEL description="servercore:ltsc2019 with cdas environment" maintainer="Leo"

# 安装 Chocolately 包管理器
RUN powershell.exe -Command \
	Set-ExecutionPolicy Bypass -Scope Process -Force; \
	[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
	iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 安装 Mingw-w64 和 Git
RUN choco install -y git --version 2.39.2 --params "/GitAndUnixToolsOnPath" ; \
	choco install -y mingw --version 8.1.0 ;

# 安装 Python 3.11.2
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	wget https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe -OutFile c:\python-3.11.2-amd64.exe ; \
	Start-Process c:\python-3.11.2-amd64.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait ; \
	Remove-Item c:\python-3.11.2-amd64.exe -Force

# 安装 Conan、Ninja、CMake
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Start-Process python.exe -ArgumentList '-m pip install --upgrade pip' -Wait
RUN ["pip", "install", "conan==1.59.0", "ninja==1.11.1", "cmake==3.25.2"]
   
# 安装 Clang-format 和 Clang-tidy
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	Invoke-WebRequest -OutFile clang-format.exe https://github.com/llvm/llvm-project/release/download/llvmorg-13.0.0/clang-format-13.0.0-windows.exe; \
	Invoke-WebRequest -OutFile clang-tidy.exe https://github.com/llvm/llvm-project/release/download/llvmorg-13.0.0/clang-tidy-13.0.0-windows.exe; \
	Move-Item clang-format.exe C:\Windows\System32; \
	Move-Item clang-tidy.exe C:\Windows\System32

# 安装 sonar-scanner-cli
RUN powershell -Command \
	$ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-windows.zip -OutFile c:\sonar-scanner-cli.zip ; \
	Expand-Archive -Path c:\sonar-scanner-cli.zip -DestinationPath c:\sonar-scanner-cli ; \
	Remove-Item c:\sonar-scanner-cli.zip -Force
RUN setx /M PATH "%PATH%;c:\sonar-scanner-cli\bin"

# 设置工作目录
WORKDIR /app

# 执行命令
CMD [ "powershell" ]
# Install MSVC
# RUN powershell -NoProfile -InputFormat None -Command \
#     choco install -y visualcpp-build-tools --version 15.0.26228.20170424 ; \
#     Write-Host 'Waiting for Visual C++ Build Tools to finish'; \
#     Wait-Process -Name vs_installer

# 7zip
# RUN powershell -Command \
# 	$ErrorActionPreference = 'Stop'; \
# 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# 	wget https://www.7-zip.org/a/7z2201-x64.exe -OutFile c:\7z2201-x64.exe ; \
# 	Start-Process c:\7z2201-x64.exe -ArgumentList '/S /D="c:\7-Zip"' -Wait ; \
# 	Remove-Item c:\7z2201-x64.exe -Force
# RUN setx /M Path "%path%;c:\7-Zip"

# Install mingw8.1.0
# RUN powershell -Command \
# 	$ErrorActionPreference = 'Stop'; \
# 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# 	wget https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z -OutFile c:\mingw81.7z ; \
# 	Start-Process 7z.exe -ArgumentList 'x c:\mingw81.7z c:\ ' ; \
# 	Remove-Item c:\mingw81.7z -Force
# RUN setx /M Path "%path%;c:\mingw64\bin"