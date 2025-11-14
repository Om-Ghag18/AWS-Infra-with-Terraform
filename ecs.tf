resource "aws_ecs_cluster" "main" {
  name = "main-cluster"
}

resource "aws_iam_role" "ecs_instance" {
  name = "ecs-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
}

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }
  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config")
}

resource "aws_autoscaling_group" "ecs" {
  name                = "ecs-asg"
  vpc_zone_identifier = aws_subnet.private[*].id
  load_balancers      = [aws_elb.main.name]
  health_check_type   = "ELB"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}
