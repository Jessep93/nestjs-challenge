# nestjs-test-infra
This repository houses the Infrastructure code for the challenge. The infrastructure is launched primarily within AWS.
Any steps documented toward localizing the project or running of code will take a Linux-based view.

It follows 3 tier Architecture where the infrastructure is divided into 3 different layers: web, app(application) and DB. 
Only the Web layer is open to the public while app and db layers remain private and can only be accessed by security groups linked to the web layer. This ensures security for the Backend of the project eg. RDS servers. 

Only the skeletal structure has been made for the app and db as a demonstration for the assessment.

The Load Balancer is the point of entry for the infrastructure, sending traffic to the instances managed by the auto-scaling group. 
The Autoscaling group has a minimum of 1, and a maximum 2 limits where it will scale according to the set threshold:
     - if CPU Utilization is higher than 70, scale up
     - if CPU Utilization is lower than 30 and has  more than 1 instance, scale down


# pre setup 
Make sure ec2 key pair called "test_infra" is set up on your AWS account. 
This name can be changed in the _variable.tf.



# Deployment method 
1) Export your AWS_ACCESS_KEY and the AWS_SECRET_ACCESS_KEY to cli or used already setup AWS profile
2) run the below commands:
    - terraform init
    - terraform plan -var-file="./environments/dev.tfvars" -lock=false
    - terraform apply -var-file="./environments/dev.tfvars" -lock=false
any env.tfvars file can be selected to choose which environment you want the infrastructure to be deployed in (only dev values have been set for now)

Method 2: Github actions [currently not working] 
1) Setup AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY in the github actions secrets 
2) Everytime new pr is created, terraform plan is automatically triggered in the github actions - main branch should be protected in real scenario. 
3) Once Terraform plan is finished, you can view the changes and run the APPLY actions to apply the changes (can make this process automatic if needed)

# How to improve further 

## AWS Infrastructure
1) Modularization of Codes: To improve the management and scalability of the infrastructure, it is recommended to modularize the codebase. This allows for easier reusability and maintainability of the infrastructure components.

2) Implement Highly Available Network Address: For production and staging environments, it is crucial to implement high availability by deploying infrastructure across multiple Availability Zones (AZs). This ensures redundancy and resilience in case of failures. Using modules will be lot more helpful to implement this.

3) CloudWatch Alerts and Notifications: Implement health checks and configure CloudWatch alerts to monitor the infrastructure's health and performance. Integrate the alert notifications with collaboration tools like Slack to facilitate prompt responses to any failures or issues.

4) Scheduled Scaling Down of Non-Production Environments: Implement automation to scale down non-production environments, such as development or staging, during off-hours or weekends. This optimizes cost efficiency by reducing resource utilization when not actively in use.

5) Infrastructure as Code Automation: Utilize tools like Terraform Cloud or AWS CloudFormation to automate the infrastructure provisioning and deployment process. Implementing infrastructure as code enables consistent and repeatable deployments across different environments.

6) Container Implementation with ECS or EKS: Consider utilizing container orchestration platforms like Amazon Elastic Container Service (ECS) or Amazon Elastic Kubernetes Service (EKS) to deploy and manage containerized applications. This allows for improved scalability, availability, and easier deployment of application images stored in the Elastic Container Registry (ECR).

## Infrastructure Pipelining

![Infra pipeline](doc/InfraPipeline.jpeg?raw=true "Infrastructure pipeline")


1) Trigger: Set up triggers to initiate the pipeline, such as pull requests (PRs) merged into the main branch.

2) Automated Deployment with Terraform: Use Terraform Cloud or similar tools to automate the deployment process for each environment (e.g., development, staging, production) using separate workspaces. This ensures consistent and reliable infrastructure provisioning.

3) Collaboration and Notifications: Integrate collaboration tools like Slack or Microsoft Teams to receive notifications and updates on the progress and status of the infrastructure pipeline.

## Application Pipelining

![App pipeline](doc/ApplicationPipeline.jpeg?raw=true "Application pipeline")

1) Trigger: Use PRs merged into the main branch as the trigger to start the application pipeline.

2) Continuous Integration/Deployment (CI/CD): Choose a suitable CI/CD tool such as Jenkins, Azure DevOps, or others to set up the pipeline for building and deploying the application.

3) Docker Image Creation: Create a Docker image of the application code and push it to an image repository such as Amazon Elastic Container Registry (ECR).

4) Deployment: Deploy the application to the appropriate AWS services based on your infrastructure design, such as EC2 instances, ECS clusters, or EKS clusters.

5) Multi-Environment Deployment: Once the application is successfully deployed and tested in one environment (e.g., development), trigger the pipeline to deploy it to subsequent environments (e.g., QA, staging, production) in a controlled and automated manner.

6) Collaboration and Notifications: Integrate collaboration tools like Slack or Microsoft Teams to receive notifications and updates on the progress and status of the application pipeline.
