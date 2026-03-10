Write-Host "🚀 Starting installation for Course Registration System..."

$repo = "https://github.com/Kumaresan-31/Course_Registration_System/archive/refs/heads/main.zip"
$temp = "$env:TEMP\course_system.zip"
$extract = "$env:TEMP\course_system"

Write-Host "📥 Downloading project..."
Invoke-WebRequest $repo -OutFile $temp

Write-Host "📦 Extracting files..."
Expand-Archive $temp -DestinationPath $extract -Force

$projectPath = "$extract\Course_Registration_System-main"

Set-Location $projectPath

Write-Host "📦 Installing backend dependencies..."
Set-Location backend
npm install

Write-Host "📦 Installing frontend dependencies..."
Set-Location ../frontend
npm install

Write-Host "✅ Installation completed!"