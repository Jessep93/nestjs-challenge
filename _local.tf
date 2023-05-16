## Tags
locals {
  tags = {
    CostCenter  = var.project
    Environment = var.environment
    Owner       = "Build Team"
    ManagedBy   = "terraform"
  }

  name_prefix = "${var.environment}-${lower(var.project)}"
}


#Password for RDS
resource "random_password" "rds_password" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = all
  }
}