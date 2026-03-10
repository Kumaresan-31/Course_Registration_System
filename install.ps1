Write-Host "🚀 Starting installation for Course Registration System..." -ForegroundColor Cyan

# Check for Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue) -and !(Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Node.js or npm is not installed. Please install it first." -ForegroundColor Red
    return
}

# Install backend dependencies
Write-Host "📦 Installing backend dependencies..." -ForegroundColor Cyan
if (Test-Path "backend") {
    Set-Location backend
    npm install
    Set-Location ..
} else {
    Write-Host "❌ Error: backend directory not found." -ForegroundColor Red
    return
}

Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "✨ Next steps:"
Write-Host "1. Run the database schema 'database.sql' in your MySQL instance."
Write-Host "2. Edit 'backend/.env' with your database credentials."
Write-Host "3. Run 'npm start' in the 'backend' folder to start the server."
