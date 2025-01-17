output "vpc_id" {
     value=module.vpc_setup.vpc_id 
}

output "public_subnets_ids"{
     value=module.vpc_setup.public_subnets_ids 
}

output "private_subnets_ids"{   
     value=module.vpc_setup.private_subnets_ids 
}

output "internet_gateway_id"{   
     value=module.vpc_setup.internet_gateway_id 
}

output nat_gateway{
     value=module.vpc_setup.nat_gateway  
}
