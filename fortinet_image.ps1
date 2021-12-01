param ($file, $version)

$name = (Get-ChildItem $file).Name
$hash = (Get-FileHash -Algorithm MD5 $file).Hash.ToLower()
$size = (Get-ChildItem $file).Length

$images = @{
    filename = $name;
    version = $version;
    md5sum = $hash;
    filesize = $size;
    download_url = "https://support.fortinet.com/Download/FirmwareImages.aspx";
}

$versions = @{
    name = $version;
    images = @{
        hda_disk_image = $name;
        hdb_disk_image = "empty30G.qcow2";
    }
}

Write-Output "# images"
$images | ConvertTo-Json

Write-Output "# versions"
$versions | ConvertTo-Json