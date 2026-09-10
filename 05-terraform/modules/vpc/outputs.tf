# modules/vpc/outputs.tf

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the created VPC"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "ID of the created public subnet"
}
