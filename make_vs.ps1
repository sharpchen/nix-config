# This file generates a vs.exe to open directory with visual studio
#Requires -RunAsAdministrator
$devenv = (vswhere -latest -property productPath)
if (Test-Path $devenv) {
  Install-Module -Name ps2exe -Scope CurrentUser -Confirm
  $scriptPath = [System.IO.Path]::Combine($env:TEMP, "vs_alias.ps1")
  $scriptContent = @"
      param (
        [System.IO.DirectoryInfo]`$path = [System.IO.DirectoryInfo]::new([System.Environment]::CurrentDirectory)
      ) 
      `$slns = (Get-ChildItem ([System.IO.Path]::Combine(`$path.FullName, '*.sln')))
      `$proj = (Get-ChildItem ([System.IO.Path]::Combine(`$path.FullName, '*proj')))
      if (`$slns) {
          if (`$slns -is [System.IO.FileInfo]) {
              & `"$devenv`" "`$(`$slns.FullName)`"
          } elseif (`$slns -is [Array]) {
              & `"$devenv`" "`$(`$slns[0].FullName)`"
          }
          return
      } elseif (`$proj) {
          if (`$proj -is [System.IO.FileInfo]) {
              & `"$devenv`" "`$(`$proj.FullName)`"
          } elseif (`$proj -is [Array]) {
              & `"$devenv`" "`$(`$proj[0].FullName)`"
          }
          return
      }
      Write-Warning "`$(`$path.FullName)` contains no *proj or *.sln"
      
      #& `"$devenv`" "`$(`$path.FullName)`"
"@
  Write-Output $scriptContent
  $scriptContent | Out-File -FilePath $scriptPath -Force
  $devenvParent = [System.IO.Path]::GetDirectoryName($devenv)
  $vsExePath = [System.IO.Path]::Combine($devenvParent, 'vs.exe')
  $buildCommand = "ps2exe `"$scriptPath`" `"$vsExePath`" -verbose"
  powershell -NoProfile -Command $buildCommand
  if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $devenvParent }).Count) {
    [System.Environment]::SetEnvironmentVariable(
      'Path', 
      $env:PATH + ';' + $devenvParent,
      [System.EnvironmentVariableTarget]::User
    )
    Write-Output "$devenvParent added to PATH."
    Write-Output 'Please open a new session to refresh PATH in case you add it too many times'
  }
} else {
    Write-Error 'This machine does not have visual studio correctly installed.'
}
