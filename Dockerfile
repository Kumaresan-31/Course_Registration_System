# Use Node.js base image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy backend package files
COPY backend/package*.json ./backend/

# Install backend dependencies
RUN cd backend && npm install

# Copy all project files
COPY . .

# Expose port (default 3000)
EXPOSE 3000

# Command to start the server
CMD ["node", "backend/server.js"]
