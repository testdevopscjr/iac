resource "aws_instance" "bastion-tf" {
  ami           = "ami-0f62d9254ca98e1aa"
  instance_type = "t3.micro"
  #vpc_id        =aws_vpc.vpc.id
  subnet_id     =aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "bastion-tf"
    terraform=true
  }
}


resource "aws_instance" "apache-tf" {
  ami           = "ami-0f62d9254ca98e1aa"
  instance_type = "t3.micro"
  #vpc_id        =aws_vpc.vpc.id
  subnet_id     =aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.apache.id]

  tags = {
    Name = "apache-tf"
    terraform=true
  }
}