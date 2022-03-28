resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion-sg"
  description = "Egress All"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
