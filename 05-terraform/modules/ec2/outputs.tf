# modules/ec2/outputs.tf

output "instance_id" {
  value       = aws_instance.this.id
  description = "ID of the created EC2 instance"
}

output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "Public IP address of the created EC2 instance"
}
