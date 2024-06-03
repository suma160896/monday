provider "aws" {
  region = "us-east-1" # Replace with your desired region
}
resource "aws_ecr_repository" "my_repo" {
  name                 = "my-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
#added comment ffffff
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "default" {
  id = "subnet-00360f0e694d69d21"  # Replace with your Subnet ID
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
resource "aws_instance" "web" {
   ami           = data.aws_ami.ubuntu.id# Replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.default.id
  key_name               = aws_key_pair.instance_key.key_name
  #instance_type          = var.instance_type
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "MyInstance"
  }
}

resource "aws_key_pair" "instance_key" {
  key_name   = "instance_key"
  public_key = file(var.path_to_linux_key)
  
  
}