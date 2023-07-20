output "vpc_id" { 
    value = aws_vpc.main.id
}

output "public_subnets" { 
    value =  aws_route_table_association.public-subnets
}

output "private_subnets" { 
    value =  aws_route_table_association.private-subnets
}