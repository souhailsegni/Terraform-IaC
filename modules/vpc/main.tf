resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igw.id
    #description               = "Public Route to IGW"
  }

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create NAT Gateway in the first public subnet
resource "aws_eip" "nat_eip" {
  domain = "vpc"  # Allocate an Elastic IP for the NAT Gateway.
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id    = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

# Create Private Route Tables and Associate with Private Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block                = "0.0.0.0/0"
    nat_gateway_id            = aws_nat_gateway.nat_gw.id # Route traffic through NAT Gateway.
    #description               = "Private Route to NAT Gateway"
  }

  tags = {
    Name = "${var.name}-private-route-table"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Security Group for Public Subnets (Web Servers)
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.http_port 
    to_port     = var.http_port 
    protocol    = var.protocol 
    cidr_blocks = ["0.0.0.0/0"]

    description ="Allow HTTP traffic"
   }

   ingress {
     from_port=var.https_port 
     to_port=var.https_port  
     protocol=var.protocol 
     cidr_blocks=["0.0.0.0/0"]

     description="Allow HTTPS traffic"
   }

   egress {
     from_port=0 
     to_port=0 
     protocol="-1"
     cidr_blocks=["0.0.0.0/0"]

     description="Allow all outbound traffic"
   }

   tags={
      Name="${var.name}-public-sg"
   }
}

# Security Group for Private Subnets (Restrict access)
resource "aws_security_group" "private_sg" {
   vpc_id=aws_vpc.vpc.id

   ingress{
      from_port=3306 # Example: MySQL port.
      to_port=3306 
      protocol="tcp"
      security_groups=[aws_security_group.public_sg.id] # Allow access from public SG
      
      description="Allow MySQL access from public subnet."
   }

   egress{
      from_port=0 
      to_port=0 
      protocol="-1"
      cidr_blocks=["10.0.0.0/16"] # Allow internal communication.

      description="Allow all outbound traffic."
   }

   tags={
      Name="${var.name}-private-sg"
   }
}
