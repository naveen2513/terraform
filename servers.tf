
resource "aws_instance" "frontend" {
  ami           = "ami-03265a0778a880afb"
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z04520141JRLZY4JX3O8T"
  name    = "frontend-dev.naveendevops1.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}
