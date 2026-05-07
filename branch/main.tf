# AWS Provider
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# 1. Launch configuration with unencrypted EBS block device
resource "aws_launch_configuration" "bad_lc" {
  name_prefix   = "bad-lc-"
  image_id      = "ami-0c55b159cbfafe1f0" # Example Amazon Linux AMI
  instance_type = "t2.micro"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = false  # ❌ Unencrypted EBS
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 10
    encrypted   = false  # ❌ Unencrypted EBS
  }

  # 6. EC2 Instances are NOT EBS-Optimized
  ebs_optimized = false # ❌ Not EBS optimized
}

# 2. Security Group with ingress from 0.0.0.0/0
resource "aws_security_group" "bad_sg" {
  name        = "bad-sg"
  description = ""  # ❌ Missing description (point 4)

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Wide open ingress (point 2)
    description = ""  # ❌ Missing description (point 4)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. EC2 Instance with IMDSv1 enabled (i.e., no restriction)
resource "aws_instance" "bad_instance" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-12345678"
  vpc_security_group_ids = [aws_security_group.bad_sg.id]

  # 8. Monitoring disabled (detailed monitoring OFF)
  monitoring = false  # ❌ No detailed monitoring

  # No metadata options configured → IMDSv1 enabled by default (point 7)

  ebs_optimized = false # Redundant here to emphasize point 6
}


