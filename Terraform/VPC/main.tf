provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.20.3.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "priv-sub-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.20.4.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "priv-sub-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# EIP for NAT Gateway
resource "aws_eip" "nat_eip_1" {
  vpc = true
  tags = {
    Name = "nat-eip-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  vpc = true
  tags = {
    Name = "nat-eip-2"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name = "nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_2.id
  tags = {
    Name = "nat-gw-2"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = {
    Name = "private-rt-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }
  tags = {
    Name = "private-rt-2"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}

# Bastion Host in public subnet
resource "aws_instance" "bastion" {
  ami                    = "ami-0dc8f119f40fa49f7" # Amazon Linux 2 AMI (update as needed)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1.id
  associate_public_ip_address = true
  key_name               = "your-key-name"  # Replace with your actual key
  tags = {
    Name = "bastion-host"
  }
}

# NACLs (Optional basic setup)
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
}

# VPC Peering Placeholder
# Define 1 more VPC and create aws_vpc_peering_connection (not included unless requested)

