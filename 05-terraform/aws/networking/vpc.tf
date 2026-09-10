# networking/vpc.tf — REFERENCE ONLY
# Mirrors the VPC resource from ../main.tf, split out here purely for
# readability while studying. See ../README.md for why this folder is
# reference material rather than a directly-runnable configuration.

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}
