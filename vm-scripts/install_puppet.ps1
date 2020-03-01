# Write-Output "Disable Security scanning..."
# Set-MpPreference -DisableArchiveScanning $true -DisableRealtimeMonitoring $true
Write-Output "Installing Puppet..."
cd c:\vagrant\modules\software\files
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/qn /norestart /i puppet-agent-6.4.2-x64.msi" -wait
Write-Output "Puppet installed"
