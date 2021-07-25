#------------------------------------------------------------------------
#---------------DB Param Group-------------------------------------------
#------------------------------------------------------------------------

resource "aws_db_parameter_group" "appd-db-parameter-group" {

  name        = "appd-db-parameter-group"
  family      = "aurora-mysql5.7"
  description = "Custom parameter group for AppDynamics"

  parameter {
    name         = "innodb_file_format"
    value        = "Barracuda"
    apply_method = "pending-reboot"

  }

    parameter {
    name         = "innodb_large_prefix"
    value        = "1"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = "180"
    apply_method = "pending-reboot"
  }


  parameter {
    name         = "innodb_max_dirty_pages_pct"
    value        = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "lock_wait_timeout"
    value        = "180"
    apply_method = "pending-reboot"
  }

   parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "pending-reboot"
  }

 parameter {
    name         = "max_allowed_packet"
    value        = "104857600"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_heap_table_size"
    value        = "1610612736"
    apply_method = "pending-reboot"
  }


  parameter {
    name         = "query_cache_type"
    value        = "0"
    apply_method = "pending-reboot"
  }
 

  parameter {
    name         = "sql_mode"
    value        = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tmp_table_size"
    value        = "67108864"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wait_timeout"
    value        = "31536000"
    apply_method = "pending-reboot"
  }

  tags = {
    Component   = "DB"
    Application = "AppDynamics"
  }

}


#--------------------------------------------------------------------------------
#---------------DB CLUSTER Param Group-------------------------------------------
#--------------------------------------------------------------------------------

resource "aws_rds_cluster_parameter_group" "appd-db-cluster-parameter-group" {


  name        = "appd-dbcluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "Custom db cluster parameter group for AppDynamics"

  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "binary"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8_general_ci"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8_unicode_ci"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_default_row_format"
    value        = "DYNAMIC"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_per_table"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  }

  tags = {
    Component   = "DB"
    Application = "AppDynamics"
  }

}

output "db_param_group_id" {
    value = aws_db_parameter_group.appd-db-parameter-group.id
}

output "db_cluster_param_group_id" {
    value = aws_rds_cluster_parameter_group.appd-db-cluster-parameter-group.id

}