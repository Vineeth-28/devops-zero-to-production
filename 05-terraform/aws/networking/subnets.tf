# networking/subnets.tf — REFERENCE ONLY
# See ../README.md — mirrors ../main.tf.

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block               = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
  }
}
