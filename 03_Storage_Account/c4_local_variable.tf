# Define local variables

locals {
  project              = var.project
  environment          = var.environment
  resource_name_prefix = "${var.project}-${var.environment}"

  project_tags = {
    project     = local.project
    environment = local.environment
  }
}