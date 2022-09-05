locals {
  component      = "ps-base"

  default_tags = {
    Environment = var.environment
    Component   = local.component
  }

}