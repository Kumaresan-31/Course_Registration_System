Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Clear-Host
Write-Host "================" -ForegroundColor Cyan
Write-Host "🚀 COURSE REGISTRATION SYSTEM INSTALLER" -ForegroundColor White -BackgroundColor Blue
Write-Host "================" -ForegroundColor Cyan
Write-Host ""

# --- CONFIGURATION PROMPTS ---
Write-Host "🛠️  Database Configuration" -ForegroundColor Yellow
$dbUser = Read-Host "👤 Enter MySQL Username (default: root)"
if ([string]::IsNullOrWhiteSpace($dbUser)) { $dbUser = "root" }

$dbPass = Read-Host "🔑 Enter MySQL Password" -AsSecureString
$passPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPass)
$plainPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($passPtr)

Write-Host "📍 Database Host: localhost" -ForegroundColor Gray
$dbHost = "localhost"
$dbName = "course_registration"

Write-Host ""
Write-Host "⚙️  Starting installation process..." -ForegroundColor Cyan

$tempPath = "$env:TEMP\course_system"
$zipPath = "$tempPath\project.zip"

if (Test-Path $tempPath) {
    Write-Host "🧹 Cleaning up old temp files..." -ForegroundColor Gray
    Remove-Item $tempPath -Recurse -Force
}

New-Item -ItemType Directory -Path $tempPath | Out-Null

Write-Host "📥 Downloading project from GitHub..." -ForegroundColor Magenta
Invoke-WebRequest "https://github.com/Kumaresan-31/Course_Registration_System/archive/refs/heads/main.zip" -OutFile $zipPath

Write-Host "📦 Extracting files..." -ForegroundColor Magenta
Expand-Archive $zipPath -DestinationPath $tempPath -Force

$projectPath = "$tempPath\Course_Registration_System-main"

# --- CREATE .ENV FILE ---
Write-Host "💾 Configuring environment variables..." -ForegroundColor Yellow
$envContent = @"
DB_HOST=$dbHost
DB_USER=$dbUser
DB_PASSWORD=$plainPass
DB_NAME=$dbName
DB_PORT=3306
SERVER_PORT=3000
"@

$backendEnvPath = "$projectPath\backend\.env"
$envContent | Out-File -FilePath $backendEnvPath -Encoding utf8

# --- SETUP DATABASE ---
Write-Host "🗄️  Setting up MySQL database..." -ForegroundColor Yellow
if (Get-Command mysql -ErrorAction SilentlyContinue) {
    try {
        $sqlPath = "$projectPath\database.sql"
        # Try to run the SQL file. We use --execute to pass the password if reachable or just let it prompt if needed, 
        # but here we use -p$plainPass directly (careful with spaces).
        $cmd = "mysql -u $dbUser '-p$plainPass' -e 'source $sqlPath'"
        cmd /c $cmd 2>$null
        Write-Host "✅ Database schema imported successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to import database. Please run database.sql manually." -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  MySQL CLI not found in PATH. Skipping automatic database setup." -ForegroundColor DarkYellow
    Write-Host "👉 Please import '$projectPath\database.sql' manually." -ForegroundColor Gray
}

# --- INSTALL DEPENDENCIES ---
function Run-Npm {
    param([string]$folder)
    $originalPath = Get-Location
    Set-Location $folder
    Write-Host "⚡ Running npm install in $folder..." -ForegroundColor DarkGray
    cmd /c "npm install --quiet"
    Set-Location $originalPath
}

if (Test-Path "$projectPath\backend\package.json") {
    Write-Host "📦 Installing backend dependencies..." -ForegroundColor Cyan
    Run-Npm "$projectPath\backend"
}

if (Test-Path "$projectPath\frontend\package.json") {
    Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Cyan
    Run-Npm "$projectPath\frontend"
}

Write-Host ""
Write-Host "✨ INSTALLATION COMPLETED SUCCESSFULLY! ✨" -ForegroundColor Green -BackgroundColor Black
Write-Host "------------------------------------------" -ForegroundColor Cyan
Write-Host "📁 Project Location: $projectPath" -ForegroundColor White
Write-Host "🚀 To start the server:" -ForegroundColor Yellow
Write-Host "   1. cd '$projectPath\backend'" -ForegroundColor Gray
Write-Host "   2. npm start" -ForegroundColor Gray
Write-Host "------------------------------------------" -ForegroundColor Cyan