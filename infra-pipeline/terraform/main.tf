provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-05ffe3c48a9991133"
  instance_type = "t2.micro"
  key_name      = "kops-key"

  vpc_security_group_ids = ["sg-008f5a006740e2d5b"]

  tags = {
    Name = "WebServer"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
