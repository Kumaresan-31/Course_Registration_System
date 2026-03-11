#!/bin/bash

# --- COLORS ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE_BG='\033[44m'
WHITE='\033[1;37m'

clear
echo -e "${CYAN}================${NC}"
echo -e "${WHITE}${BLUE_BG} 🚀 COURSE REGISTRATION SYSTEM INSTALLER ${NC}"
echo -e "${CYAN}================${NC}"
echo ""

# --- CONFIGURATION PROMPTS ---
echo -e "${YELLOW}🛠️  Database Configuration${NC}"
read -p "👤 Enter MySQL Username (default: root): " DB_USER
DB_USER=${DB_USER:-root}

read -s -p "🔑 Enter MySQL Password: " DB_PASS
echo ""

DB_HOST="localhost"
DB_NAME="course_registration"

echo -e "\n${CYAN}⚙️  Starting installation process...${NC}"

# Check for Node.js
if ! [ -x "$(command -v node)" ] && ! [ -x "$(command -v npm)" ]; then
  echo -e "${RED}❌ Error: Node.js or npm is not installed. Please install it first.${NC}" >&2
  exit 1
fi

# --- CREATE .ENV FILE ---
echo -e "${YELLOW}💾 Configuring environment variables...${NC}"
if [ -d "backend" ]; then
    cat <<EOF > backend/.env
DB_HOST=$DB_HOST
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASS
DB_NAME=$DB_NAME
DB_PORT=3306
SERVER_PORT=3000
EOF
    echo -e "${GREEN}✅ .env file created.${NC}"
else
    echo -e "${RED}❌ Error: backend directory not found. skipping .env creation.${NC}"
fi

# --- SETUP DATABASE ---
echo -e "${YELLOW}🗄️  Setting up MySQL database...${NC}"
if command -v mysql &> /dev/null; then
    mysql -u "$DB_USER" -p"$DB_PASS" -e "source database.sql" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Database schema imported successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to import database. Please run database.sql manually.${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  MySQL CLI not found in PATH. Skipping automatic database setup.${NC}"
    echo -e "👉 Please import 'database.sql' manually."
fi

# --- INSTALL DEPENDENCIES ---
echo -e "${CYAN}📦 Installing backend dependencies...${NC}"
if [ -d "backend" ]; then
    cd backend && npm install --quiet
    cd ..
else
    echo -e "${RED}❌ Error: backend directory not found.${NC}"
    exit 1
fi

echo -e "\n${GREEN}✨ INSTALLATION COMPLETED SUCCESSFULLY! ✨${NC}"
echo -e "${CYAN}------------------------------------------${NC}"
echo -e "${WHITE}🚀 To start the server:${NC}"
echo -e "   1. cd backend"
echo -e "   2. npm start"
echo -e "${CYAN}------------------------------------------${NC}"

