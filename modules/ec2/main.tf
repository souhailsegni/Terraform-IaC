
resource "aws_instance" "public_ec2" {
  count                  = length(var.public_subnet_ids)

  ami                    = var.ec2_ami
  instance_type = terraform.workspace == "prod" ? "t3.micro" : "t2.micro"
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group]
  subnet_id             = var.public_subnet_ids[count.index]

 tags = {
    Name = "${terraform.workspace}-PublicInstance"
    Environment = "${terraform.workspace}"
  }
}
