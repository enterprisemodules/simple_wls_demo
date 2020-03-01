Write-Output 'Installing required puppet modules...'
cd c:\vagrant
iex "& 'c:\Program Files\Puppet Labs\Puppet\puppet\bin\r10k.bat' puppetfile install --verbose"
Write-Output 'Installing required puppet modules finished.'
