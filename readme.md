### Keycloak cluster
The purpose of this repository is to experiment deploying a Keycloak instance on AWS ECS service using terraform for IaC, I am currently using Open Tofu which is a terraform fork for the Ioc. 

![Web App Reference Architecture (5)](https://github.com/Millroy094/keycloak-cluster-aws-terraform/assets/58091953/247fa1e4-dd91-41f1-b2d9-2037fa8f2ebb)

The network consists on 3 subnets. One public subnet for load balancer and two private subnets for the ecs, and database instances respectively. The load balancer forwards all HTTP requests made by the user to port 8080 of the Keycloak ECS instance. The ECS is not connected to the internet but rather only accepts HTTP requests on 8080 from the load balancer. It also connects to the DB instances and the VPC endpoints to enable it access to ECR and CloudWatch Logs.
   
