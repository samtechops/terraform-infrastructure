locals {
  component      = "ps-application"

  default_tags = {
    Environment = var.environment
    Component   = local.component
  }

}