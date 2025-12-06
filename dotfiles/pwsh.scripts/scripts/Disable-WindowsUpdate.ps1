# WARN: this script isn't completed because I don't really know whether they're sufficient

sc stop wuauserv # Windows Update
sc stop uhssvc # Windows Update Health Service
sc stop WaaSMedicSvc # Windows Update Medic Service
sc stop UsoSvc # Update Orchestrator Service
sc stop BITS

sc config wuauserv start= disabled # disable auto start
sc config uhssvc start= disabled
sc config WaaSMedicSvc start= disabled
sc config UsoSvc start= disabled
sc config BITS start= disabled

sc failure wuauserv reset= 0 actions= '' # disable recovery actions
# TODO: maybe add failure action for all services above?

reg add 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' /v 'FlightSettingsMaxPauseDays' /t REG_DWORD /d '0x00002727' /f *> $null

if (Test-Path C:\Windows\SoftwareDistribution) {
    Remove-Item 'C:\Windows\SoftwareDistribution\*' -Recurse -Force
}
