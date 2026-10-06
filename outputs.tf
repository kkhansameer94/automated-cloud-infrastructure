output "vpc_id" {
  description = "The ID of the custom VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}
