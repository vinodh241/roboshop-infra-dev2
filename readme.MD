
# Roboshop infra # By VINODH AVALA 
-------------------------------------------------------------------------------

Terraform provisions infrastructure, Ansible configures systems, Docker packages applications, and Kubernetes manages application runtime. Terraform is not suitable for deployments because it is state-driven and not designed for continuous runtime management, scaling, or self-healing. Kubernetes is built exactly for that purpos

 By using Terraform , AWS cloud , Shell , Ansible  creating instances and configuring env ,deploying to Target environments

 * Bastion server --> ( jump box/ server)

# TERRAFORM:
-----------------------------------------------------------------------------------

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

# How to create resources  in multiple aws accounts 
-------------------------------------------------------------------------------------
  * * ( Need two aws accounts ) 

    * ex:  dev , staging , uat , prod 

  * one aws account --> one provider --> ( .aws/credentials)


  * we have to mention in provider like

        provider {
         alias = dev
         profile = dev
          }

        provider {
        alias = prod
        profile = prod
          }

    * in sg group we have mention 

        * provider = aws.dev #for dev
        * provider = aws.prod #for prod

  * * ( suppose if you want to create for dev)

        * aws configure --profile dev
        * aws configure --profile prod

  # someone pollouted the resources manually in AWS. How to manage this?
  ----------------------------------------------------------------------------------

   * Terraform taint  --> force AWS to create the resources 

        * terraform taint  --> it modifes the terraform state file ( as if it were missing or invalid terraform will destroy the old resources and create a new based on your current configuration )

  # Infra created Manually , how can you manage that with terraform ?
  -----------------------------------------------------------------------------------

       * Actuall process with terraform is-> write ( .tf files ) with this create infra in AWS then store in (.sate ) files   

  * terraform import 
    ---------------
    * infra is in aws   --> you need to get that into .tf files 
    1. write a provider
    2. write a resource block with no arguments , then terraform init 
    3. then terraform import 

    ----------------------------------------------------------------------------------------------------- 
               terraform import aws_instance.<name of the instance> <instance_id>  # run this command 
      ---------------------------------------------------------------------------------------------------
    4. then terraform fetch all the data about resources into a state file 

    * once import done copy the values from state file and create as per instance creation
     

*  changes for pertuclur components 
  ------------------------------------------------------------------------------------------------------

* if you want to change only one component ( terraform plan -target='module.component["catalogue"]')

# Terraform life-cycle
  
        lifecycle {
        create_before_destroy = true
        }
   1. terraform will create another resource
   2. replace sg in instance with new sg 
   3. them it will remove old sg 


# Ansible for configuration Management 
--------------------------------------------------------------------------------------

 1. Ansible pull concept 
 * pulls playbooks form a version control systme and execute them on target hosts

# AWS: ( Services) :
---------------------------------------------------------------------------------------

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
    * ( content delivery network )--> cache management


# Databases:
--------------------------------------------------------------------------------------------

1. redis
2. mongodb
3. mysql
4. rabbitmq

# CI/CD 
--------------------------------------------------------------------------------------------
* Jenkins

# Monitoring Tools
----------------------------------------------------------------------------------------------

* Promotheous 
* Grafana



##  VINODH AVALA # .AB
