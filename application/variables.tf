variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for ASG instances."
  default     = "t3.small"
}

variable "volume_size" {
  type        = string
  description = "EC2 EBS volume size"
  default     = "30"
}

variable "volume_type" {
  type        = string
  description = "EC2 EBS volume type"
  default     = "gp2"
}

variable "ec2_asg_minimum_size" {
    default = "1"
}   

variable "ec2_asg_maximum_size" { 
    default = "1"
}

variable "ec2_asg_desired_capacity" {
    default = "1"   
}

variable "image_tag" {
  default = "3a4e2fc97508b66d96979614000b32e02d9f08bc"
}