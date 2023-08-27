resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnets" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 2, count.index)

  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_internet_gateway_attachment" "igw_asso" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.main.id
}

resource "aws_default_network_acl" "default_acl" {
  default_network_acl_id = aws_vpc.main.id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default-acl"
  }
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-sg"
  }
}

resource "aws_default_route_table" "public_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "default-rt"
  }
}

resource "aws_route_table" "pritate_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnets[1]
  route_table_id = aws_route_table.pritate_rt.id
}

resource "aws_default_vpc_dhcp_options" "default_dhcp_op" {
  tags = {
    Name = "default-dhcp-op"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-west-2.s3"

  tags = {
    Name = "s3-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.pritate_rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}