
#to print the AZ
output "AZ" {
    value=data.aws_availability_zones.available.names
  
}

#to print the vpcid
output "VPCID" {
    value=aws_vpc.vpc.id
  
}

#to print the arn of igw
output "IGWID" {
    value=aws_internet_gateway.igw.arn
  
}


#to print the length of AZ
output "LengthofAZ" {

    value=length(data.aws_availability_zones.available.names)
  
}