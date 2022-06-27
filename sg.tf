resource "aws_security_group" "ssm_example" {
  name        = "ssm-example"
  description = "Security group for SSM example EC2 instance."
  vpc_id      = var.vpc_id
  tags        = { Name = "ssm-example" }

  ingress {
    description = "Self"
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
