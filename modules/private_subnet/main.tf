resource "aws_subnet" "this_subnet" {
  vpc_id = var.vpc_id

  cidr_block = var.subnet_cidr_block
  availability_zone = var.az
  map_public_ip_on_launch = false

  tags = {
    Name = var.name
    Owner = var.owner
    Env = var.environment
  }
}

resource "aws_route_table" "this_rtb" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-route-table"
    Owner = var.owner
    Env = var.environment
  }
}

resource "aws_route_table_association" "this_rout_table_association" {
  subnet_id = aws_subnet.this_subnet.id
  route_table_id = aws_route_table.this_rtb.id
}