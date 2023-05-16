#Load balancer will be attached to ASG for scalability
resource "aws_lb" "web_lb" {
  name            = "${local.name_prefix}-Web-LB"
  internal        = false
  security_groups = [aws_security_group.web_sg.id]
  subnets         = [aws_subnet.web.id, aws_subnet.web.id]
}

resource "aws_lb_target_group" "web_lb_target_group" {
  name     = "${local.name_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_lb_target_group.arn
  }
}