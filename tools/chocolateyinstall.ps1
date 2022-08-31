$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipArchivePath = Join-Path -Path $toolsDir -ChildPath 'green-tunnel-windows.zip'

$outerPackageArgs = @{
  fileFullPath = $zipArchivePath
  destination  = $toolsDir
  packageName  = $env:ChocolateyPackageName
}
Get-ChocolateyUnzip @outerPackageArgs

#Clean up ZIP archive post-extraction to prevent unnecessary disk bloat
Remove-Item -Path $zipArchivePath -Force -ErrorAction SilentlyContinue

$extractedDirectoryPath = Join-Path -Path $toolsDir -ChildPath 'builds'
$selfExtractingArchivePath = Join-Path -Path $extractedDirectoryPath -ChildPath 'green-tunnel-installer.exe'

#The self-extracting archive terminates after spawning a detached child process.
#Emulate this to enable proper process tracking.
$tempDirectory = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'SquirrelTemp'
$innerPackageArgs = @{
  fileFullPath = $selfExtractingArchivePath
  destination  = $tempDirectory
  packageName  = $env:ChocolateyPackageName
}
Get-ChocolateyUnzip @innerPackageArgs

$installerPath = Join-Path -Path $tempDirectory -ChildPath 'Update.exe'
$installerArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'EXE'
  file           = $installerPath
  softwareName   = 'green-tunnel'
  silentArgs     = '--install . -s'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @installerArgs

#Clean up extracted contents post-install to prevent unnecessary disk bloat
Get-ChildItem -Path $tempDirectory -Exclude 'SquirrelSetup.log' -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
Remove-Item -Path $extractedDirectoryPath -Recurse -Force -ErrorAction SilentlyContinue
if (Test-Path -Path $selfExtractingArchivePath)
{
  #If the installer binary removal fails, try to prevent shim creation
  Set-Content -Path "$selfExtractingArchivePath.ignore" -Value $null -ErrorAction SilentlyContinue
}
