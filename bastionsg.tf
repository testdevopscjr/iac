#Calling ip from outside i.e my ip instead of hard code in sg cidr range
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
# #vpc
# data "aws_vpc" "vpc" {
#     filter {
#       name="tag:Name"
#       values=["TF-vpc"]
#     }
  
# }


#bastion SG
resource "aws_security_group" "bastion" {
  name        = "TF1-bastion-sg"
  description = "Allow ssh"
  #gget voc from data line 6
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "connecting admin on ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]


  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF-bastion-sg"
    terraform="true"
  }
}




