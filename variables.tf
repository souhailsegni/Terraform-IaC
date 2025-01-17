variable region { default="eu-west-1"}
variable "ec2_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0e9085e60087ce171"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
  default     = "my-ec2-key"
}
