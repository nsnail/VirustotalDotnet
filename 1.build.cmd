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