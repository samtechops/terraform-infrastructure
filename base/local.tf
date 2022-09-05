locals {
  component      = "ps-base-1"

  default_tags = {
    Environment = var.environment
    Component   = local.component
  }

}