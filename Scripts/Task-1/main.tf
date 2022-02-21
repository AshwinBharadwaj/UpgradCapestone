provider "aws" {
  region = "${var.region}"
}

#S3 Backend
terraform {
  backend "s3" {
    bucket         = "ashwin-bharadwaj-capstone"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

#VPC
resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "${var.TagName}-vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.TagName}-igw"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet-1a" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = "${var.publicsub_1}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.TagName}-public-subnet-1a"
  }
}

resource "aws_subnet" "public_subnet-1b" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = "${var.publicsub_2}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.TagName}-public-subnet-1b"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet-1a" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = "${var.privatesub_1}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.TagName}-private-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet-1b" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = "${var.privatesub_2}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.TagName}-private-subnet-1b"
  }
}

#Elastic IP
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

#Nat Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet-1a.id
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "${var.TagName}-nat"
  }
}

#Routing Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.TagName}-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.TagName}-private-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id 
}

#Route table associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet-1a.id  
  route_table_id = aws_route_table.public.id  
}

resource "aws_route_table_association" "private" {  
  subnet_id      = aws_subnet.private_subnet-1a.id
  route_table_id = aws_route_table.private.id
}
