output "vpc" {
    value = data.terraform_remote_state.network.outputs.vpc_id
}

output "lb_endpoint" { 
    value = aws_lb.alb.dns_name
}