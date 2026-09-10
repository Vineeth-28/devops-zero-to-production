# modules/ec2/main.tf

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "this" {
  ami                    = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.environment}-${var.name}"
    Environment = var.environment
  }
}
