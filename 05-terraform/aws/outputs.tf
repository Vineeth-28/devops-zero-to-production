# outputs.tf

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "ID of the public subnet"
}

output "backend_instance_id" {
  value       = aws_instance.backend.id
  description = "ID of the backend EC2 instance"
}

output "backend_public_ip" {
  value       = aws_instance.backend.public_ip
  description = "Public IP address of the backend EC2 instance"
}

output "artifacts_bucket_name" {
  value       = aws_s3_bucket.artifacts.bucket
  description = "Name of the S3 bucket used for build artifacts"
}
