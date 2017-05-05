 
function UnZipMe($zipfilename, $destination)
{
 $shellApplication = new-object -com shell.application
 $zipPackage = $shellApplication.NameSpace($zipfilename)
 $destinationFolder = $shellApplication.NameSpace($destination)
 
# CopyHere vOptions Flag # 4 - Do not display a progress dialog box.
# 16 - Respond with "Yes to All" for any dialog box that is displayed.
 
$destinationFolder.CopyHere($zipPackage.Items(),20)
}
# Install IIS if required
Import-Module Servermanager
 
$check = Get-WindowsFeature | Where-Object {$_.Name -eq "web-server"}
 
If (!($check.Installed)) {
 Write-Host "Adding web-server"
 Add-WindowsFeature web-server
}
 
$name = "NetHelloWorld"
$physicalPath = "C:\inetpub\wwwroot\" + $name
 
  Write-Host "physical path : " + $physicalPath

# Create Application Pool
try
{
 $poolCreated = Get-WebAppPoolState $name –errorvariable myerrorvariable
 Write-Host $name "Already Exists"
}
catch
{
 # Assume it doesn't exist. Create it.
 New-WebAppPool -Name $name
 Set-ItemProperty IIS:\AppPools\$name managedRuntimeVersion v4.0
}
 
# Create Folder for the website
if(!(Test-Path $physicalPath)) {
 md $physicalPath
}
else {
 Remove-Item "$physicalPath\*" -recurse -Force
}
 
$site = Get-WebSite | where { $_.Name -eq $name }
if($site -eq $null)
{
 Write-Host "Creating site: $name $physicalPath"
 
 # TODO:
 New-WebSite -Name $name  -Port 80 -PhysicalPath "C:\inetpub\wwwroot\NetHelloWorld" -ApplicationPool $name | Out-Null
  Write-Host "Creating application: $name $physicalPath"
 New-WebApplication -Site $name -Name $name -PhysicalPath "C:\inetpub\wwwroot\NetHelloWorld" -ApplicationPool $name
}
 
UnZipMe -zipfilename "c:\HelloWorld.zip" -destination "C:\inetpub\wwwroot\NetHelloWorld"