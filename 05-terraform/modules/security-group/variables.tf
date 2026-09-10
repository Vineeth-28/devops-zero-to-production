# modules/security-group/variables.tf

variable "environment" {
  type        = string
  description = "Environment name, used for tagging and naming"
}

variable "name" {
  type        = string
  description = "Short name for this security group, e.g. 'web'"
  default     = "web"
}

variable "description" {
  type        = string
  description = "Security group description"
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID this security group belongs to"
}

variable "ingress_rules" {
  description = "List of ingress rules to create"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
