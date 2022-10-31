data "aws_availability_zones" "available" {
  state = "available"
}

#vpc
resource "aws_vpc" "vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames ="true"

  tags = {
    Name = "TF-vpc"
    terraform="True"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "TF-igw"
  }
}

#public Subnet
#creating 3 subnets at once
resource "aws_subnet" "public" {
  #to iterate AZ length
  count=length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  #calling public cidr range from variable.tf and making a list for iteration
  cidr_block = element(var.pub-cidr,count.index)
  map_public_ip_on_launch="true"
  availability_zone =element(data.aws_availability_zones.available.names,count.index)
  tags = {
    Name = "TF-public-${count.index+1}-subnet"
  }
}


# resource "aws_subnet" "public2" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.1.1.0/24"
#   map_public_ip_on_launch="true"
#   availability_zone =data.aws_availability_zones.available.names[1]
#   tags = {
#     Name = "public2-subnet"
#   }
# }


# resource "aws_subnet" "public3" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.1.2.0/24"
#   map_public_ip_on_launch="true"
#   availability_zone =data.aws_availability_zones.available.names[1]
#   tags = {
#     Name = "public3-subnet"
#   }
# }
#private subnet
resource "aws_subnet" "private" {
  #to iterate AZ length
  count=length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  #calling public cidr range from variable.tf and making a list for iteration
  cidr_block = element(var.private-cidr,count.index)
  map_public_ip_on_launch="false"
  availability_zone =element(data.aws_availability_zones.available.names,count.index)
  tags = {
    Name = "TF-private-${count.index+1}-subnet"
  }
}



#data subnet
#private subnet
resource "aws_subnet" "datasubnet" {
  #to iterate AZ length
  count=length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.vpc.id
  #calling public cidr range from variable.tf and making a list for iteration
  cidr_block = element(var.data-cidr,count.index)
  map_public_ip_on_launch="false"
  availability_zone =element(data.aws_availability_zones.available.names,count.index)
  tags = {
    Name = "TF-data-${count.index+1}-subnet"
  }
}

#elasticip
resource "aws_eip" "EIP" {
  
  vpc      = true
  tags = {
    Name = "TF-EIP"
  }
}


#nat gateway
resource "aws_nat_gateway" "NatGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "TF-NAT GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_eip.EIP
  ]
}


#route table
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  
  tags = {
    Name = "TF-Public-route"
  }
}


#private route
resource "aws_route_table" "Private-route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NatGW.id
  }

  
  tags = {
    Name = "TF-Private-route"
  }
}


#routetable association
resource "aws_route_table_association" "Public-asso" {
  count=length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "private-asso" {
  count=length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.Private-route.id
}

resource "aws_route_table_association" "data" {
  count=length(aws_subnet.private[*].id)
  subnet_id      = element(aws_subnet.datasubnet[*].id,count.index)
  route_table_id = aws_route_table.Private-route.id
}




 