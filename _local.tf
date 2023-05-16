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


