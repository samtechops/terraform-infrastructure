locals {
  component      = "ps-service"

  default_tags = {
    Environment = var.environment
    Component   = local.component
  }

}