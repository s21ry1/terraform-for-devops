# Terraform EC2 Services Example
# This file contains 10 different EC2-related resources, each as a separate resource block

provider "aws" {
  region = "us-east-1"
}

# 1. EC2 Key Pair
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD... user@example"
}

# 2. Security Group
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.example.id]
  tags = {
    Name = "ExampleInstance"
  }
}

# 4. EBS Volume
resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 8
  tags = {
    Name = "ExampleVolume"
  }
}

# 5. Volume Attachment
resource "aws_volume_attachment" "example" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}

# 6. Elastic IP
resource "aws_eip" "example" {
  instance = aws_instance.example.id
  vpc      = true
}

# 7. Network Interface
resource "aws_network_interface" "example" {
  subnet_id       = aws_instance.example.subnet_id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.example.id]
}

# 8. Launch Template
resource "aws_launch_template" "example" {
  name_prefix   = "example-lt-"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
}

# 9. Placement Group
resource "aws_placement_group" "example" {
  name     = "example-pg"
  strategy = "cluster"
}

# 10. Autoscaling Group
resource "aws_autoscaling_group" "example" {
  name                      = "example-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_instance.example.subnet_id]
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ExampleASG"
    propagate_at_launch = true
  }
}
