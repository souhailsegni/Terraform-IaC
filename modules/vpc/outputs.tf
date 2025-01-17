output "vpc_id" {
    value=aws_vpc.vpc.id 
}

output "public_subnets_ids"{
     value=aws_subnet.public_subnet[*].id 
}

output "private_subnets_ids"{   
     value=aws_subnet.private_subnet[*].id 
}

output "internet_gateway_id"{   
     value=aws_internet_gateway.igw.id 
}

output nat_gateway{
     value=aws_nat_gateway.nat_gw.id  
}
output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

