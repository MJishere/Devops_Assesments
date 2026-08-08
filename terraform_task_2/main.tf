terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}

provider "aws" {
  alias  = "region1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "region2"
  region = "us-west-2"
}

# Get the latest AMI for amazon linux - region 1

data "aws_ssm_parameter" "amazon_linux_region1" {
  provider = aws.region1
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Get the latest AMI for amazon linux - region 2

data "aws_ssm_parameter" "amazon_linux_region2" {
  provider = aws.region2
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Default VPC - Region 1

data "aws_vpc" "region1" {
  provider = aws.region1

  default = true
}

# Default VPC - Region 2

data "aws_vpc" "region2" {
  provider = aws.region2

  default = true
}


# Security Group - Region 1

resource "aws_security_group" "nginx_region1" {
  provider = aws.region1

  name        = "nginx-sg-region1"
  description = "Allow HTTP traffic for Nginx"
  vpc_id      = data.aws_vpc.region1.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg-region1"
  }
}

# Security Group - Region 2

resource "aws_security_group" "nginx_region2" {
  provider = aws.region2

  name        = "nginx-sg-region2"
  description = "Allow HTTP traffic for Nginx"
  vpc_id      = data.aws_vpc.region2.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg-region2"
  }
}


# Ec2 - Region 1
resource "aws_instance" "ec2_region1" {
  provider = aws.region1

  ami                         = data.aws_ssm_parameter.amazon_linux_region1.value
  instance_type               = "t3.micro"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.nginx_region1.id
  ]

  user_data = file("${path.module}/nginx.sh")

  tags = {
    Name        = "nginx-server-region1"
    Environment = "assessment"
  }
}

# Ec2 - Region 2

resource "aws_instance" "ec2_region2" {
  provider = aws.region2

  ami                         = data.aws_ssm_parameter.amazon_linux_region2.value
  instance_type               = "t3.micro"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.nginx_region2.id
  ]

  user_data = file("${path.module}/nginx.sh")

  tags = {
    Name = "nginx-server-region2"
  }
}

# outputs

output "region1_instance_id" {
  value = aws_instance.ec2_region1.id
}

output "region1_public_ip" {
  value = aws_instance.ec2_region1.public_ip
}

output "region2_instance_id" {
  value = aws_instance.ec2_region2.id
}

output "region2_public_ip" {
  value = aws_instance.ec2_region2.public_ip
}
