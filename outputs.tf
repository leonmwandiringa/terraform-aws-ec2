output "public_ip" {
  description = "Public IP of instance (or EIP)"
  value       = aws_instance.default.public_ip
}

output "private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.default.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = aws_instance.default.private_dns
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"
  value       = aws_instance.default.public_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = aws_instance.default.id
}

output "arn" {
  description = "ARN of the instance"
  value       = aws_instance.default.arn
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value = var.security_groups
}

output "role" {
  description = "Name of AWS IAM Role associated with the instance"
  value       = var.instance_profile
}

output "role_arn" {
  description = "ARN of AWS IAM Role associated with the instance"
  value       = var.instance_profile
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = aws_instance.default.primary_network_interface_id
}

output "instance_profile" {
  description = "Name of the instance's profile (either built or supplied)"
  value       = var.instance_profile
}
