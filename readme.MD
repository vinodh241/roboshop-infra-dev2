
# Roboshop infra #
-----------------

 By using Terraform , AWS cloud , Shell , Ansible  creating instances and configuring env ,deploying to Target environments

 * Bastion server --> ( jump box/ server)

# TERRAFORM:

* Terraform Modules
* Terraform Provisioners
* Terraform providers
* Terraform workspace 
* Terraform null resources   
   -- it will not create any resources , but it will just follow the life cycle of terraform ( like plan, destroy ).. ..# using to connet to the instances 
* Terraform state
* Terraform variables
* Terraform locals
* Terraform data sources

# changes for pertuclur components 
* if you want to change only one component ( terraform plan -target='module.component["catalogue"]')



# Ansible for configuration Management 

 1. Ansible pull concept 
 * pulls playbooks form a version control systme and execute them on target hosts

# AWS: ( Services) :

 1.  VPC 
 2.  subnets
   * (i) public-subnet and  private-subnet
 3.  IGW -Interner Gate way
 4.  NAT gateway 
 5.  Availability zones
 6.  Route-tables
 7.  Elastic IP 
 8.  vpc-peering 
 9.  Load balancing 
 10. Target groups ( creating target groups and hnadover or attached to autoscaling groups)
 11. SSM parameter store
 12. ACM ( Aws certificate Manager) 
 13. CDN 
# Databases:

1. redis
2. mongodb
3. mysql
4. rabbitmq

# CI/CD 
* Jenkins

# Monitoring Tools

* Promotheous 
* Grafana




