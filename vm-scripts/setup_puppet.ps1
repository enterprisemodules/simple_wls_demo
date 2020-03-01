#
# Install R10K. We need this to download the correct set of puppet modules
#
Write-Output "Installing required gems..."
iex "& 'c:\Program Files\Puppet Labs\Puppet\puppet\bin\gem.bat' install r10k"
Write-Output "Installing required gems finished"


Write-Output 'Installing required puppet modules...'
cd c:\vagrant
iex "& 'c:\Program Files\Puppet Labs\Puppet\puppet\bin\r10k.bat' puppetfile install"
Write-Output 'Installing required puppet modules finished.'

#
# Setup hiera search and backend. We need this to config our systems
#
Write-Output "Setting up hiera directories"
New-Item -Path "C:\ProgramData\PuppetLabs\code\environments\production\hieradata" -ItemType SymbolicLink -Value "c:\Vagrant\hieradata" -Force
New-Item -Path "C:\ProgramData\PuppetLabs\code\environments\production\hiera.yaml" -ItemType SymbolicLink -Value "c:\Vagrant\hiera.yaml" -Force

#
# Configure the puppet path's
#
Write-Output "Setting up Puppet module directories"
New-Item -Path "C:\ProgramData\PuppetLabs\code\environments\production\modules" -ItemType SymbolicLink -Value "c:\Vagrant\modules" -Force

Write-Output "Setting up Puppet manifest directories"
New-Item -Path "C:\ProgramData\PuppetLabs\code\environments\production\manifests" -ItemType SymbolicLink -Value "c:\Vagrant\manifests" -Force
Write-Output "Puppet setup completed."
