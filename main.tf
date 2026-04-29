provider "aws" {
  region = "eu-north-1"
}

# Security Group (same as your current rules)
resource "aws_security_group" "skillpulse_sg" {
  name        = "skillpulse-sg"
  description = "Allow SSH, HTTP, App Port"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
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

# Latest Ubuntu AMI (auto fetch)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-amd64-server-*"]
  }
}

# EC2 Instance
resource "aws_instance" "skillpulse_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  availability_zone = "eu-north-1b"

  vpc_security_group_ids = [aws_security_group.skillpulse_sg.id]

  tags = {
    Name = "skillpulse-demo-server"
  }
}
