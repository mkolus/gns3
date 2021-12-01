param ($file, $version, $download_url)

Add-Type -assembly "system.io.compression.filesystem"

$file = (Get-ChildItem $file).Name
$realname = $file -replace "\.zip$", ""

$zip = [io.compression.zipfile]::OpenRead($file)
$archived_file = $zip.Entries | Where-Object { $_.Name -eq $realname }
$size = $archived_file.Length
[System.IO.Compression.ZipFileExtensions]::ExtractToFile($archived_file, $realname, $true)
$zip.Dispose()

$hash = (Get-FileHash -Algorithm MD5 $realname).Hash.ToLower()

$images = @{
    filename = $realname;
    version = $version;
    md5sum = $hash;
    filesize = $size;
    download_url = "http://www.mikrotik.com/download";
    direct_download_url = "https://download.mikrotik.com/routeros/{0}/{1}" -f $version, $file;
    compression = "zip"
}

$versions = @{
    name = $version;
    images = @{
        hda_disk_image = $realname;
    }
}

Write-Output "# images"
$images | ConvertTo-Json

Write-Output "# versions"
$versions | ConvertTo-Json