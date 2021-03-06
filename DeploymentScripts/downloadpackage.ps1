# The region associated with your bucket e.g. eu-west-1, us-east-1 etc. (see http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-regions)
	$region = "us-east-1"
	# The name of your S3 Bucket
	$bucket = "533159-bucket"
	# The folder in your bucket to copy, including trailing slash. Leave blank to copy the entire bucket
	$keyPrefix = ""
	# The local file path where files should be copied
	$localPath = "C:\"

	$objects = Get-S3Object -BucketName $bucket -KeyPrefix $keyPrefix -Region $region

	foreach($object in $objects) {
		$localFileName = $object.Key -replace $keyPrefix, ''
		if ($localFileName -ne '') {
			$localFilePath = Join-Path $localPath $localFileName
			Copy-S3Object -BucketName $bucket -Key $object.Key -LocalFile $localFilePath  -Region $region
			 Write-Host "File from S3 Path is  : " + $localFilePath
		}
	}
	