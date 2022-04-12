# Define local variables

locals {
  project =var.project
  environment = var.environment
  resource_name_prefix = "${var.project}-${var.environment}"
  winserver_name_prefix ="${var.project}${var.environment}${var.winos}"
  linuxserver_name_prefix ="${var.project}${var.environment}${var.linuxos}"
  project_tags = {
      project = local.project
      environment = local.environment 
  }
}