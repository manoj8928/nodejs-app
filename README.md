# Node.js App with DynamoDB Integration
This repository contains a Node.js application that interacts with AWS DynamoDB. Here are the steps to set up the project locally using Docker and Docker Compose.

# Prerequisites
- Docker
- Docker Compose
- AWS Credentails (Need need read/write permission to DynamoDB table)

# Example APP
The example Node.js app includes dummy code and tests. We have two main endpoints in this application `/status` which provide status of server is up and running and `/data` which accepts POST request in form of JSON Body.

# Local Setup with Docker Compose

1. Clone the Repository

```shell
git clone https://github.com/manoj8928/nodejs-app.git
cd nodejs-app
```
2. Using Docker Compose

Make sure you have Docker and Docker Compose installed. With Docker Compose, we can orchestrate the launch of both the Node.js application and the local DynamoDB in tandem.

```shell
docker-compose up
```
This command will start both the Node.js app and DynamoDB. The application will be configured to connect to DynamoDB using the links defined in the docker-compose.yml file.

3. Testing the Application

    1. Health Check Endpoint

     Verify the application is running:   

    ```shell
    curl http://localhost:3000/status
    ```
    You should receive a response like:

    ```shell
    {"status":"Up and running!"}
    ```
    2. Data Endpoint

    Test the data endpoint with a POST request:

    ```shell
    curl -X POST http://localhost:3000/data -H 'Content-Type: application/json' -d '{"login":"abc","demo":"my_password"}'
    ```
    This will send data to be stored in the local DynamoDB instance. A successful response will include a unique ID for the data item.

# Deploying the Application

This application uses GitHub Actions to automate its deployment. Here are the steps to deploy the application using the provided CI/CD pipeline:

1. Setup AWS Credentials in GitHub Secrets:

Navigate to your repository on GitHub.
-  Go to "Settings" -> "Secrets".
-  Click "New repository secret" and add the following secrets:
-  AWS_ACCESS_KEY_ID: Your AWS access key.
-  AWS_SECRET_ACCESS_KEY: Your AWS secret access key.

Note: IAM credentails needs permission to push docker image. to ECR and Deploy Infrastructure
 
These secrets are used by the GitHub Actions workflow to authenticate and push Docker images to ECR, and apply infrastructure changes with Terraform.

2. Triggering the CI/CD Pipeline:

Any push to branches will automatically trigger the CI/CD pipeline.
The pipeline will:
-  Checkout the code.
-  Install Node.js dependencies.
-  Build and push the Docker image to AWS ECR.
-  Deploy the infrastructure using Terraform.

3. Monitoring the Workflow:
 
-  Go to the "Actions" tab on your repository to see the progress of the workflow.
-  If any step fails, you can click into the workflow run to view the logs and diagnose the issue.

4. Manual Approval for Infrastructure Deployment:

-  The workflow includes a manual approval step for Terraform changes.
-  When the deployment reaches this step, an administrator will need to review the changes and approve them before the deployment continues.

5. Accessing the Deployed Application:

-  Once the CI/CD pipeline completes, the application will be accessible through the URL of the Application Load Balancer created by Terraform.