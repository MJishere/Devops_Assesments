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

# Ec2 - Region 1
resource "aws_instance" "ec2_region1" {
  provider = aws.region1

  ami           = data.aws_ssm_parameter.amazon_linux_region1.value
  instance_type = "t3.micro"
}

# Ec2 - Region 2

resource "aws_instance" "ec2_region2" {
  provider = aws.region2

  ami           = data.aws_ssm_parameter.amazon_linux_region2.value
  instance_type = "t3.micro"
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
