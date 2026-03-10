#!/bin/bash
echo "🚀 Starting installation for Course Registration System..."

# Check for Node.js
if ! [ -x "$(command -v node)" ] && ! [ -x "$(command -v npm)" ]; then
  echo "❌ Error: Node.js or npm is not installed. Please install it first." >&2
  exit 1
fi

# Install backend dependencies
echo "📦 Installing backend dependencies..."
if [ -d "backend" ]; then
    cd backend && npm install
    cd ..
else
    echo "❌ Error: backend directory not found."
    exit 1
fi

echo "✅ Installation complete!"
echo "✨ Next steps:"
echo "1. Run the database schema 'database.sql' in your MySQL instance."
echo "2. Edit 'backend/.env' with your database credentials."
echo "3. Run 'npm start' in the 'backend' folder to start the server."
