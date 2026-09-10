# variables.tf
# Root-level input variables for the example AWS project.

variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the backend server"
  default     = "t3.micro"
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for build artifacts"
}
