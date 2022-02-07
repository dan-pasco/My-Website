provider "aws" {

    region = "ap-southeast-2"
  
}


# Create Main VPC
resource "aws_vpc" "custom_vpc" {

    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Custom VPC"
    }
  
}


# Created 1st public subnet

resource "aws_subnet" "pubsub-1" {

    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-2a"
    map_public_ip_on_launch = true

    tags = {
      Name = "pubsub-2a"
    }

  
}

#Created 2nd public subnet

resource "aws_subnet" "pubsub-2" {

    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-southeast-2b"
    map_public_ip_on_launch = true


    tags = {
      Name = "pubsub-2b"
    }

  
}
 #Define Internet Gateway
 resource "aws_internet_gateway" "custom_ig" {

     vpc_id = aws_vpc.custom_vpc.id

     tags = {
       Name = "custom ig"
     }
   
 }

# Define Routing Table
resource "aws_route_table" "custom_rt" {

    vpc_id = aws_vpc.custom_vpc.id

   
   route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.custom_ig.id

   }

   tags = {

       Name = "Routing Rules"

   }
  
}

# Associate the Subnets
resource "aws_route_table_association" "rt-association-pub1" {
    subnet_id = aws_subnet.pubsub-1.id
    route_table_id = aws_route_table.custom_rt.id
  
}

resource "aws_route_table_association" "rt-association-pub2" {
    subnet_id = aws_subnet.pubsub-2.id
    route_table_id = aws_route_table.custom_rt.id
  
}

