# Node.js App with DynamoDB Integration
This repository contains a Node.js application that interacts with AWS DynamoDB. Here are the steps to set up the project locally using Docker and Docker Compose.

# Prerequisites
Docker
Docker Compose
AWS Credentails (Need need read/write permission to DynamoDB table)

## Example APP
The example Node.js app includes dummy code and tests. We have two main endpoints in this application `/status` which provide status of server is up and running and `/data` which accepts POST request in form of JSON Body.

# Local Setup with Docker Compose

# 1. Clone the Repository

```shell
git clone https://github.com/manoj8928/nodejs-app.git
cd nodejs-app
```
# Using Docker Compose

Make sure you have Docker and Docker Compose installed. With Docker Compose, we can orchestrate the launch of both the Node.js application and the local DynamoDB in tandem.

```shell
docker-compose up
```
This command will start both the Node.js app and DynamoDB. The application will be configured to connect to DynamoDB using the links defined in the docker-compose.yml file.

# 3. Testing the Application

# a. Health Check Endpoint

Verify the application is running:   

```shell
curl http://localhost:3000/status
```
You should receive a response like:

```shell
{"status":"Up and running!"}
```
# b. Data Endpoint

Test the data endpoint with a POST request:

```shell
curl -X POST http://localhost:3000/data -H 'Content-Type: application/json' -d '{"login":"abc","demo":"my_password"}'
```
This will send data to be stored in the local DynamoDB instance. A successful response will include a unique ID for the data item.

