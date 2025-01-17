variable "public_subnet_ids" {
  description = "List of public subnet IDs where EC2 instances will be deployed."
  type        = list(string)
}

variable "ec2_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

variable "security_group" {
  description = "Security group ID for the instance"
  type        = string
}
