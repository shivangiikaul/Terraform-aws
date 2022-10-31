resource "aws_vpc" "test-vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = var.az

  tags = {
    cretaed-by = "Shivangi"
  }
}

resource "aws_subnet" "test-subnet2" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = var.subnet_cidr2
  availability_zone = var.az2

  tags = {
    cretaed-by = "Shivangi"
  }
}

resource "aws_internet_gateway" "test-gateway" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    created-by = "shivangi"
  }
}

resource "aws_route_table" "test-route" {
  vpc_id = aws_vpc.test-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-gateway.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test-route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.test-subnet2.id
  route_table_id = aws_route_table.test-route.id
}




