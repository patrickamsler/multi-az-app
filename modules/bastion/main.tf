resource "aws_security_group" "bastion_host_security_group" {
  name = "${var.name}-security-group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // TODO restrict access
    description = "HTTP access"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-security-group"
    Owner = var.owner
    Env = var.environment
  }
}

resource "aws_instance" "bastion_host" {
  ami           = "ami-0adbe59da7d24a349"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = var.subnet_id
  key_name = var.key_name
  security_groups = [aws_security_group.bastion_host_security_group.id]
  tags = {
    Name = var.name
    Owner = var.owner
    Env = var.environment
  }
}