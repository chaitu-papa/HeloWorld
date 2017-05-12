$launchInstance = "C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 -Schedule"
$readyInstance = "C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SendWindowsIsReady.ps1 -Schedule"

Write-Host "before $launchInstance"

Invoke-Expression $launchInstance

Write-Host "before $readyInstance"
Invoke-Expression $readyInstance


Write-Host "before New-NetFirewallRule"

New-NetFirewallRule -DisplayName "Allow Inbound Port 81" -Direction Inbound –LocalPort 81 -Protocol TCP -Action Allow

Write-Host "after New-NetFirewallRule"