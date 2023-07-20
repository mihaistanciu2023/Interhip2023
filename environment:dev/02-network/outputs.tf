output "vpc_id" { 
    value = module.network.vpc_id
}

output "public_subnets" { 
    value = module.network.public_subnets[*].subnet_id
}

output "private_subnets" { 
    value = module.network.private_subnets[*].subnet_id
}