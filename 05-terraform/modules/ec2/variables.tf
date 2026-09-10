# modules/ec2/variables.tf

variable "environment" {
  type        = string
  description = "Environment name, used for tagging and naming"
}

variable "name" {
  type        = string
  description = "Short name for this instance, e.g. 'backend'"
  default     = "backend"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "Optional explicit AMI ID. If omitted, the latest Ubuntu 22.04 AMI is used."
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance into"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}
