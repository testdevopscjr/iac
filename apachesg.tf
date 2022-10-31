


#apache SG
resource "aws_security_group" "apache" {
  name        = "TF1-apache-sg"
  description = "Allow apache"
  #gget voc from data line 6
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "SSH from admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups     = [aws_security_group.bastion.id]


  }

  ingress {
    description      = "For ALB endusers"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups      = [aws_security_group.ALB.id]


  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF-apache-sg"
    terraform="true"
  }
}




