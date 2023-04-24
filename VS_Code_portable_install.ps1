# Run from where this script is saved
# Download the latest portable Visual Studio Code zip file
$url = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
$response = Invoke-WebRequest -Uri $url -Method Head
$originalFilename = [System.IO.Path]::GetFileName($response.BaseResponse.ResponseUri.LocalPath)

$scriptLocation = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$outputFile = Join-Path -Path $scriptLocation -ChildPath $originalFilename
Write-Host $outputFile
Invoke-WebRequest -Uri $url -OutFile $outputFile

# Ask user to enter the drive for extraction
$drive = Read-Host -Prompt 'Enter the drive letter for extraction (e.g., C, D, E)'

# Use the original downloaded zip file name as the new folder name
$folderName = [System.IO.Path]::GetFileNameWithoutExtension($outputFile)
$extractPath = Join-Path -Path "$($drive):\" -ChildPath $folderName

# Extract
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($outputFile, $extractPath)

# Add a folder named 'data'
$dataFolderPath = Join-Path -Path $extractPath -ChildPath 'data'
New-Item -ItemType Directory -Path $dataFolderPath

# Output completion message
Write-Host "Visual Studio Code has been successfully extracted to $extractPath"