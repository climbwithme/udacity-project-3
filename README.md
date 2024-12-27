# Coworking Space Service Extension

## Pre-requisites
1. Python Environment - run Python 3.6+ applications and install Python dependencies via `pip`
2. Docker CLI - build and run Docker images locally
3. `kubectl` - run commands against a Kubernetes cluster
4. `aws configure` - all credential information are set

## Remote Resources
1. AWS CodeBuild - build Docker images remotely
2. AWS ECR - host Docker images
3. Kubernetes Environment with AWS EKS - run applications in k8s
4. AWS CloudWatch - monitor activity and logs in EKS
5. GitHub - pull and clone code


## 1. First time setup

#### a. AWS Cluster Creation
```bash
eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name my-nodes --node-type t3.small --nodes 1 --nodes-min 1 --nodes-max 2
```
#### b. DB SETUP
Run the below deployment files using `kubectl` & update necessary data in the database tables

```
kubectl apply -f filepath\name.yaml
```

[pv.yaml](deployment/pv.yaml), 
[pvc.yaml](deployment/pvc.yaml) & 
[postgresql-deployment.yaml](deployment/postgresql-deployment.yaml)
[postgresql-service.yaml](deployment/postgresql-service.yaml)

#### c. ECR - CodeBuild configuration

Setup ECR and Codebuild to have webhhook based on pull request merge condition.
Use the [Docker File](Dockerfile) for testing locally.  
Use the [Buildspec File](buildspec.yaml) for testing via ECR-CodeBuild.


![CodeBuild Setup](evidences\00_code_build_01_build_history.png)
![ECR Config](evidences\01_ECR_01_repo_details.png)
![ECR Config](evidences\01_ECR_02_created_image.png)

#### b. APP SETUP
Run the below deployment files using `kubectl`:


[db-configmap.yaml](deployment/db-configmap.yaml), 
[db-secret.yaml](deployment/db-secret.yaml) [base 64 encrypted password is to be added here] & 
[analytics-api.yaml](deployment/analytics-api.yaml)

## 2. Releasing a new build

CodeBuild will create a new build whenever a new PULL REQUEST is merged via github.

#### a. Pipeline configuration
![CodeBuild Setup](evidences\00_code_build_02_project_config.png)


## 3. Verification of the setup

Use `kubectl` commands to validate the services and pods running statuses

#### a. Services Details
![Kubectl validation](evidences\02_kubectl_screenshot_01.png)
![Kubectl validation](evidences\02_kubectl_screenshot_02.png)


## 4. Validate with cloudwatch insights

Use the application log under cluser to validate the health check of the application:

![Cloudwatch Log Events](evidences\03_cloudwatch_00_Insights_log_events.png)

Monitor the utilization of the pods via Insights page: 

![Cloudwatch Map View](evidences\03_cloudwatch_02_map_view.png)

## 5. External IP  Endpoints: 

[DAILY USAGE] http://a3a9cd15b5fd94bcd8f958694f6cffdb-1501814250.us-east-1.elb.amazonaws.com:5153/api/reports/daily_usage
![DAILY USAGE](evidences\04_Result_Daily_Usage.png)

[USER VISITS] http://a3a9cd15b5fd94bcd8f958694f6cffdb-1501814250.us-east-1.elb.amazonaws.com:5153/api/reports/user_visits 
![USER VISITS](evidences\04_Result_User_Visit.png)