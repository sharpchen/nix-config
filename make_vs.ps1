#Requires -RunAsAdministrator
$devenv = (vswhere -latest -property productPath)
if (Test-Path $devenv) {
  #if (-not Test-Path ([System.IO.Path]::Combine($devenv.Parent.FullName, 'vs.exe'))) {
  Install-Module -Name ps2exe -Scope CurrentUser -Confirm
  $scriptPath = [System.IO.Path]::Combine($env:TEMP, "vs_alias.ps1")
  $scriptContent = @"
      param (
        [System.IO.DirectoryInfo]`$dir = [System.IO.DirectoryInfo]::new([System.Environment]::CurrentDirectory)
      ) 
      & `"$devenv`" "`$(`$dir.FullName)`"
"@
  Write-Output $scriptContent
  $scriptContent | Out-File -FilePath $scriptPath -Force
  $devenvParent = [System.IO.Path]::GetDirectoryName($devenv)
  $vsExePath = [System.IO.Path]::Combine($devenvParent, 'vs.exe')
  $buildCommand = "ps2exe `"$scriptPath`" `"$vsExePath`" -verbose"
  powershell -NoProfile -Command $buildCommand
  return
  if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $devenvParent }).Count) {
    [System.Environment]::SetEnvironmentVariable(
      "Path", 
      $env:PATH + ';' + $devenvParent,
      [System.EnvironmentVariableTarget]::User
    )
    Write-Output "$devenvParent added to PATH."
    Write-Output 'Please open a new session to refresh PATH in case you add it too many times'
  }
}
