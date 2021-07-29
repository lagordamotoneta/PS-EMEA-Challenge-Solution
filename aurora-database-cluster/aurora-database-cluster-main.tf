#--------------------------------------------------------------------------------
#---------------Aurora DB-------------------------------------------
#--------------------------------------------------------------------------------

resource "aws_rds_cluster" "default" {
  cluster_identifier = "appd-database"
  master_username    = var.db_username
  master_password    = var.db_password
  port               = 3388
  engine             = "aurora-mysql"
  engine_version                  = "5.7.12"
  availability_zones              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  vpc_security_group_ids          = [var.db_vpc_sec_group_id]
  db_cluster_parameter_group_name = var.db_cluster_param_group_name
  skip_final_snapshot             = true
  storage_encrypted               = true
  tags = {
    Component   = "DB"
    Application = "AppDynamics"
  }
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.default.endpoint
}


resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier = "appd-database-instance"
  count              = 1
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t2.small"
  engine = "aurora-mysql"
  engine_version          = "5.7.12"
  db_parameter_group_name = var.db_param_group_name
  publicly_accessible     = true
  tags = {
    Component   = "DB"
    Application = "AppDynamics"
  }

}

#We made available the created resources' ids as outputs for them to be available in the root module
output "database_endpoint" {
    value = aws_rds_cluster.default.endpoint
}

output "database_port" {
    value = aws_rds_cluster.default.port
}

