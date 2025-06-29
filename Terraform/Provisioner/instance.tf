resource "aws_instance" "web" {
  ami                    = var.amiID[var.region]
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.sample-key.key_name
  vpc_security_group_ids = [aws_security_group.dove-sg.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name    = "dove-web"
    Project = "Dove"
  }
}
