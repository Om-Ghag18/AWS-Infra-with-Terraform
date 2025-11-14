resource "aws_elb" "main" {
  name            = "main-clb"
  subnets         = aws_subnet.public[*].id
  security_groups = [aws_security_group.alb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    target              = "HTTP:80/"
  }
}
