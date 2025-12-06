# Enables gpedit.msc for Windows Family Edition

cmd /c @'
@echo off

for %F in ("%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~*.mum") do (
    dism /Online /NoRestart /Add-Package:"%F"
)

for %F in ("%SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~*.mum") do (
    dism /Online /NoRestart /Add-Package:"%F"
)
'@
