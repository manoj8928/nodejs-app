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

# Design decisions

1. Adoption of DynamoDB as the Database Solution:

- NoSQL with Node.js: Our application benefits from a NoSQL database due to its compatibility with Node.js. The asynchronous nature of Node.js pairs seamlessly with NoSQL, enhancing performance during database operations.

- Managed Service Benefits: DynamoDB, an AWS offering, stands out as a premier NoSQL choice. It’s fully managed, scaling automatically to match growing demands. This allows us to focus on application features, rather than database management.

- Operational Ease: DynamoDB takes away routine operational challenges. Tasks like hardware maintenance, software patching, and configuration are automated, freeing our team from manual oversight.

- Why Not MongoDB?: While MongoDB is a potent NoSQL option, AWS doesn't provide a managed MongoDB service akin to DynamoDB. Using DynamoDB reduces additional operational responsibilities that would come with MongoDB.

2. Choosing AWS Fargate for Deployment:

We selected AWS Fargate as our deployment platform primarily for its simplicity and integration capabilities.

- Ease of Use: Fargate provides an intuitive platform that requires minimal setup, allowing us to get our application up and running quickly without managing underlying server infrastructure.

- Fully Managed: As a serverless compute engine for containers, Fargate eliminates the need for manual server configuration or scaling. This translates to reduced operational burdens and a focus on building and refining our application.

- Seamless AWS Integration: Fargate's deep integration with various AWS services, such as CloudWatch, IAM, DynamoDB, and AWS ALB, ensures that we can harness the full power of the AWS ecosystem without complications.

3. CloudWatch for Logging:

Our choice of CloudWatch as the logging solution is rooted in its seamless compatibility within the AWS ecosystem.

- Integrated Solution: CloudWatch provides a native logging service designed for AWS resources, making it a natural fit for our infrastructure.

- Effortless Integration: With AWS Fargate, the integration is almost automatic. This ensures that we capture relevant logs without additional configurations or interventions.

- Centralized Monitoring: Beyond just logging, CloudWatch offers monitoring, alarming, and dashboards. This gives us a holistic view of our application's performance and health.

4. Dockerizing the Application:

The decision to Dockerize our application was driven by the need for consistent environments, scalability, and seamless deployments.

- Consistency Across Environments: Docker ensures that the application runs the same way, regardless of where the container is launched - be it a developer's local machine or in the cloud.

- Seamless Deployment with AWS Fargate: AWS Fargate is purpose-built for running containerized applications. By Dockerizing our app, we tap into Fargate's full potential, gaining benefits like automated scaling, managed orchestration, and deep integration with other AWS services.

- Simplicity & Portability: Docker abstracts away underlying system differences. This means our development and production environments can mirror each other closely, minimizing "it works on my machine" issues.

5. Terraform for Infrastructure Management:

The choice to use Terraform as our primary Infrastructure as Code (IaC) tool was grounded in its versatility, community support, and interoperability.

- Declarative Code: Terraform's declarative syntax allows for clear and straightforward representation of infrastructure components. This makes it easier to review, understand, and modify.

- Rich Open-Source Ecosystem: The vast collection of open-source modules available for Terraform accelerates development by providing pre-written templates for common infrastructure patterns.

- Provider Agnosticism: While our primary cloud provider is AWS, Terraform's broad support for multiple cloud providers ensures our infrastructure code remains portable, should we decide to adopt a multi-cloud strategy in the future.

- State Management: Terraform's state management capabilities provide a real-time snapshot of infrastructure resources, aiding in tracking and managing changes effectively.

- Rapid Iterations: With CI/CD, we can deploy infrastructure changes rapidly, ensuring that our application's infrastructure stays agile and responsive to business needs.
