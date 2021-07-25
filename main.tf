terraform {
  required_providers {
    mysql = {
      source = "winebarrel/mysql"
      version = "1.10.4"
    }
  }
}

provider "aws"{
    region      = var.myRegion
}

provider "mysql" {
  endpoint = "${module.appd-aurora-database-cluster.database_endpoint}:${module.appd-aurora-database-cluster.database_port}"
  username = var.aurora_db_username
  password = var.aurorda_db_password
}


# in here you will give a name to your module and you will tell it which code you are going to use. In this case you will refer to
# the code in the ./security-groups module. Take a look at the code in the module and mind the outputs and outputs names!!
module "appd-platform-security-groups" {
  source = "./security-groups"
  
}
#Database Params, please be sure you create the needed groupS
module "appd-database-param-groups"{
  source = "./database-param-groups"
}

#Aurora Database
module "appd-aurora-database-cluster"{
  source = "./aurora-database-cluster"
  db_vpc_sec_group_id = module.appd-platform-security-groups.db_security_group_id
  db_param_group_name = module.appd-database-param-groups.db_param_group_id
  db_cluster_param_group_name = module.appd-database-param-groups.db_cluster_param_group_id
  region= var.myRegion
  db_username = var.aurora_db_username
  db_password = var.aurorda_db_password                              
}

#Database user: root for controller installation
module "appd-aurora-db-root-user"{
  source = "./database-root-user"
  depends_on = [module.appd-aurora-database-cluster]
}

module "appd-platform-and-controller"{
  source = "./ec2-instance"
  depends_on = [module.appd-aurora-db-root-user]
  instance_sec_group_id = module.appd-platform-security-groups.instance_security_group_id
  database_endpoint = module.appd-aurora-database-cluster.database_endpoint
  ec2_instance_type = var.instance_type
  ec2_key_name = var.key_name
  ec2_key_file = var.key_file
}


#These are the output variables from the creation of our resources so we have then handy
output "Final_Aurora_DB_Endpoint" {
  value = module.appd-aurora-database-cluster.database_endpoint
}

output "Final_ip" {
  value = module.appd-platform-and-controller.appd-platform_ip
}

output "Final_public_dns" {
  value = module.appd-platform-and-controller.appd-platform_public_dns
}

output "Final_private_dns" {
  value = module.appd-platform-and-controller.appd-platform_private_dns
}
output "Final_private_ip" {
  value = module.appd-platform-and-controller.appd-platform_private_ip
}

