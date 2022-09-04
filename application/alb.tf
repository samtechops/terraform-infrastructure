# Endpoint NLB
resource "aws_lb" "alb" {
  name               = "${local.component}-alb"
  load_balancer_type = "application"
  internal           = false
  enable_cross_zone_load_balancing = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets             = [data.terraform_remote_state.base.outputs.public_subnet_id, data.terraform_remote_state.base.outputs.public_subnet_id_2]
  tags = merge(
     {
       Name = "${local.component}-alb"
     }, 
     local.default_tags
   )
}


resource "aws_autoscaling_attachment" "attach_80" {
  autoscaling_group_name = aws_autoscaling_group.go_app.id
  lb_target_group_arn   = aws_lb_target_group.alb_80.arn
}



resource "aws_lb_target_group" "alb_80" {
  name                 = "${local.component}-80"
  port                 = 80
  protocol             = "TCP"
  vpc_id               = data.terraform_remote_state.base.outputs.vpc_id
}

resource "aws_lb_listener" "alb_8080" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_80.arn
  }
}