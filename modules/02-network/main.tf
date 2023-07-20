//creating vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { 
    Name      = "${var.name_prefix}-vpc"
    Terraform = "True"
  }
}


//creating subnets

resource "aws_subnet" "main" {
  count = var.number_of_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = var.number_of_subnets < length(var.map_az) ? "${var.region}${element(var.map_az,count.index)}" : null
  map_public_ip_on_launch = count.index < var.number_public_subnets ? true : false

  tags = {
    Name = "${var.name_prefix}-subnet-${count.index}"
    Scope = count.index > 1 ? "private" : "public"
  }
}

//creating internet gateway and natgateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}


resource "aws_eip" "eip" {
  vpc      = true
  tags = { 
    Name = "${var.name_prefix}-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.main.0.id

  tags = {
    Name = "${var.name_prefix}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


//Creating the route tables and associating the igw to the public (3 and 4) subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name_prefix}-private-rt"
  }
}

resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
}



// associating the internet gateway id and subnet ids to the public rt
resource "aws_route_table_association" "public-subnets" {
    count          = var.number_public_subnets
    subnet_id      = aws_subnet.main[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-subnets" {
    count          = var.number_private_subnets 
    subnet_id      = aws_subnet.main[count.index + var.number_public_subnets].id
    route_table_id = aws_route_table.private.id
}





//endpoint for ssm

# resource "aws_security_group" "endpoint" {
 # name        = "${var.name_prefix}-endpoint-sg"
  #description = "Allow inbound traffic"
  #vpc_id      = aws_vpc.main.id
  #ingress {
   # from_port        = 0
    #to_port          = 0
    #protocol         = "-1"
    #cidr_blocks      = ["0.0.0.0/0"]
  #}

  #egress {
   # from_port        = 0
    #to_port          = 0
    #protocol         = "-1"
    #cidr_blocks      = ["0.0.0.0/0"]
  #}

  #tags = {
   # Name = "${var.name_prefix}-sg"
  #}
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.endpoint.id,
  ]

  private_dns_enabled = true
}