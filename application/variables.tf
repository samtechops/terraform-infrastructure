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
  default = "ecc0040ebf649a0255dffe46d713a1ade00fc1df"
}