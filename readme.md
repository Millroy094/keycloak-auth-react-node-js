### Keycloak cluster
The purpose of this repository is to experiment deploying a Keycloak instance on AWS ECS service using terraform for IaC, I am currently using Open Tofu which is a terraform fork for the Ioc. 

![Web App Reference Architecture (3)](https://github.com/Millroy094/keycloak-cluster-aws-terraform/assets/58091953/15193daa-9dc4-4f01-a51d-aa0170010bc2)


![Web App Reference Architecture (4)](https://github.com/Millroy094/keycloak-cluster-aws-terraform/assets/58091953/ad36c783-9c4d-4c1b-9824-128b21c5fb26)


The network consists on 3 subnets. One public subnet for load balancer and two private subnets for the ecs, and database instances respectively. The load balancer forwards all HTTP requests made by the user to port 8080 of the Keycloak ECS instance. 

The ECS instance is not connected to the internet but rather only accepts HTTP requests on 8080 from the load balancer. It also connects to the DB instances and the VPC endpoints to enable it access to ECR and CloudWatch Logs. The ECS instance is managed by AWS via AWS Farget and is governed by an autoscaling group that can be scale up and down based on CPU utilisation.
   
