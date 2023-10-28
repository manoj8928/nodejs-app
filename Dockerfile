# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json (if available)
COPY package*.json ./

# Install the application's dependencies inside the container
RUN npm install

# Copy the rest of the application's code into the container
COPY app/ ./

# Specify the port the app runs on
EXPOSE 3000

# Define the command to run the app
CMD [ "npm", "start" ]