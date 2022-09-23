echo off
dotnet --version
if %errorlevel% == 0 (goto build)
.\res\tools\7za.exe x -y -o.\res\tools\axel .\res\tools\axel.7z
mkdir .\res\dotnet-sdk
.\res\tools\axel\axel.exe -o .\res\dotnet-sdk\dotnet-sdk-7.0.100-rc.1.22431.12-win-x64.zip https://download.visualstudio.microsoft.com/download/pr/b3b5dce4-d810-4477-a8a3-97cbb0bdf3ea/91d0dd167239cfdfb48ae18166f444d4/dotnet-sdk-7.0.100-rc.1.22431.12-win-x64.zip
if not exist .\res\dotnet-sdk\dotnet.exe (.\res\tools\7za.exe x -y -o.\res\dotnet-sdk .\res\dotnet-sdk\dotnet-sdk-7.0.100-rc.1.22431.12-win-x64.zip)
set PATH=%PATH%;%CD%\res\dotnet-sdk
:build
dotnet new console -n VirustotalDotnet -o .\src\VirustotalDotnet
copy .\src\Program.cs ".\src\VirustotalDotnet\Program.cs"
dotnet add .\src\VirustotalDotnet\VirustotalDotnet.csproj package CommandLineParser
dotnet add .\src\VirustotalDotnet\VirustotalDotnet.csproj package ShellProgressBar
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x86 --nologo -c Release -o .\dist\x86\framework-dependent
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x86 --nologo -c Release -o .\dist\x86\self-contained --sc
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x86 --nologo -c Release -o .\dist\x86\single-file --sc /p:PublishSingleFile=true
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x64 --nologo -c Release -o .\dist\x64\framework-dependent
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x64 --nologo -c Release -o .\dist\x64\self-contained --sc
dotnet publish .\src\VirustotalDotnet\VirustotalDotnet.csproj -a x64 --nologo -c Release -o .\dist\x64\single-file --sc /p:PublishSingleFile=true