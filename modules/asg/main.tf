resource "aws_security_group" "asg_security_group" {
  name = "${var.asg_name}_security-group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.asg_name}_security-group"
    Owner = var.owner
    Env = var.environment
  }
}

resource "aws_launch_template" "this_launch_template" {
  name = "${var.asg_name}_template"
  image_id = "ami-0cd31be676780afa7"
  instance_type = "t2.micro"
  key_name = var.key_name
  user_data = base64encode(file(var.user_data_filename))
  vpc_security_group_ids = [aws_security_group.asg_security_group.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.asg_name}_instance"
      Owner = var.owner
      Env = var.environment
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.asg_name}_volume"
      Owner = var.owner
      Env = var.environment
    }
  }
}

resource "aws_autoscaling_group" "this_asg" {
  name                    = var.asg_name
  vpc_zone_identifier     = var.vpc_zone_identifier
  health_check_type       = "ELB"
  min_size                = var.min_size
  max_size                = var.max_size
  launch_template {
    id      = aws_launch_template.this_launch_template.id
    version = "$Latest"
  }
  tag {
    key = "asg-name"
    propagate_at_launch = true
    value = var.asg_name
  }
}

// attach instances form auto scaling group to alb target group 
resource "aws_autoscaling_attachment" "tf_demo_alb_autoscale" {
  alb_target_group_arn   = var.alb_target_group_arn
  autoscaling_group_name = aws_autoscaling_group.this_asg.id
}