Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Write-Host "🚀 Starting installation for Course Registration System..."
$tempPath = "$env:TEMP\course_system"
$zipPath = "$tempPath\project.zip"
if (Test-Path $tempPath) {
    Remove-Item $tempPath -Recurse -Force
}
New-Item -ItemType Directory -Path $tempPath | Out-Null
Write-Host "📥 Downloading project..."
Invoke-WebRequest "https://github.com/Kumaresan-31/Course_Registration_System/archive/refs/heads/main.zip" -OutFile $zipPath
Write-Host "📦 Extracting files..."
Expand-Archive $zipPath -DestinationPath $tempPath -Force
$projectPath = "$tempPath\Course_Registration_System-main"
function Run-Npm {
    param([string]$folder)
    Set-Location $folder
    cmd /c "npm install"
}
if (Test-Path "$projectPath\backend\package.json") {
    Write-Host "📦 Installing backend dependencies..."
    Run-Npm "$projectPath\backend"
}
else {
    Write-Host "⚠️ Backend package.json not found. Skipping backend install."
}
if (Test-Path "$projectPath\frontend\package.json") {
    Write-Host "📦 Installing frontend dependencies..."
    Run-Npm "$projectPath\frontend"
}
else {
    Write-Host "⚠️ Frontend package.json not found. Skipping frontend install."
}
Write-Host "✅ Installation completed!"
Write-Host "📁 Project Location: $projectPath"