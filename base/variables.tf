variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "availability_zone" {
  type    = string
  default = "eu-west-1a"
}
