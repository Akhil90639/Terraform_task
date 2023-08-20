#Aws As Our Provider

provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAV2EKYO53NLVHWZGS"
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
  availability_zone       = "us-east-2a"
  tags = {
    Name = "public-subnet"
  }
}

# Creating private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-2b"
  tags = {
    Name = "private-subnet"
  }
}

# Creating Security Group
resource "aws_security_group" "demosg" {
  vpc_id = aws_vpc.demovpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security-group"
  }
}


# Creating EC2 instance in Public Subnet

resource "aws_instance" "instance-1" {
  ami                         = "ami-0ccabb5f82d4c9af5"
  instance_type               = "t2.micro"
  key_name                    = "insta"
  vpc_security_group_ids      = ["${aws_security_group.demosg.id}"]
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = false
  }

  tags = {
    purpose = "Assignment"
  }
}
