#Aws As Our Provider

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIARPBGYN6GVEOTMB2U"
  secret_key = "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"
}

# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo VPC"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Creating public subnet 
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}

# Creating private subnet
 # resource "aws_subnet" "private-subnet" {
  #vpc_id                  = aws_vpc.demovpc.id
  # cidr_block              = "10.0.1.0/24"
  # map_public_ip_on_launch = false
 # availability_zone       = "us-east-2b"
  # tags = {
    #Name = "private-subnet"
  # }
# }


