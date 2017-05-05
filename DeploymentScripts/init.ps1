

function DownloadDeploymentScripts()
{
	# The region associated with your bucket e.g. eu-west-1, us-east-1 etc. (see http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions)
	$region = "us-east-1"
	# The name of your S3 Bucket
	$bucket = "anjaneyademo"
	# The folder in your bucket to copy, including trailing slash. Leave blank to copy the entire bucket
	$keyPrefix = ""
	# The local file path where files should be copied
	$localPath = "C:\"

	$objects = Get-S3Object -BucketName $bucket -KeyPrefix $keyPrefix -AccessKey $accessKey -SecretKey $secretKey -Region $region

	foreach($object in $objects) {
		$localFileName = $object.Key -replace $keyPrefix, ''
		if ($localFileName -ne '') {
			$localFilePath = Join-Path $localPath $localFileName
			Copy-S3Object -BucketName $bucket -Key $object.Key -LocalFile $localFilePath -AccessKey $accessKey -SecretKey $secretKey -Region $region
		}
	}
}

function UnZipMe($zipfilename, $destination)
{
	 $shellApplication = new-object -com shell.application
	 $zipPackage = $shellApplication.NameSpace($zipfilename)
	 $destinationFolder = $shellApplication.NameSpace($destination)
	 
	# CopyHere vOptions Flag # 4 - Do not display a progress dialog box.
	# 16 - Respond with "Yes to All" for any dialog box that is displayed.
	 
	$destinationFolder.CopyHere($zipPackage.Items(),20)
}

DownloadDeploymentScripts

UnZipMe -zipfilename "c:\DeploymentScripts.zip" -destination "C:\DeploymentScripts"

Invoke-Item (start powershell ("C:\DeploymentScripts\deployment.ps1"))