resource "aws_autoscaling_group" "asg" {
  name               = "${var.name_prefix}-asg"
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.public_subnets
  target_group_arns = [aws_lb_target_group.alb.arn]
  health_check_type = "ELB"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}

resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = concat(
                        data.terraform_remote_state.network.outputs.public_subnets, 
                        data.terraform_remote_state.network.outputs.private_subnets)

}

resource "aws_lb_target_group" "alb" {
  name        = "${var.name_prefix}-alb-tg"
  //target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
}


resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}