variable "ec2_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ec2_volume_type" {
  description = "The type of the root volume for the EC2 instance."
  type        = string
  default     = "gp2"
}

variable "ec2_volume_size" {
  description = "The size of the root volume in GiB for the EC2 instance."
  type        = number
  default     = 10
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-west-2"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EC2 instance."
  type        = string
}
