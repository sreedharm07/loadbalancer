resource "aws_lb" "test" {
  name               = "${var.env}-alb"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = var.subnets
  tags = var.tags
}


resource "aws_security_group" "allow_tls" {
  name        = var.internal ? "${var.env}-private-alb-sg" : "${var.env}-public-sg"
  description = var.internal ? "${var.env}-private-alb-sg" : "${var.env}-public-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "app"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.cidr_sg
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags)
}