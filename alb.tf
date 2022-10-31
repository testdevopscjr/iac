


#ALB SG
resource "aws_security_group" "ALB" {
  name        = "TF1-ALB-sg"
  description = "Allow end user from admin"
  #gget voc from data line 6
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow end user from admin"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]


  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF-ALB-sg"
    terraform="true"
  }
}




