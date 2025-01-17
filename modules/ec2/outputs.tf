output "instance_ids" {
  value = aws_instance.public_ec2[*].id
}
