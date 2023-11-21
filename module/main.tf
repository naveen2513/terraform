
resource "aws_instance" "instances" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.component_name
  }
}
resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instances, aws_route53_record.records]
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "root"
      password = "DevOps321"
      host     = aws_instance.instances.private_ip
    }
    inline = [
      "rm -rf roboshop-scripting",
      "git clone https://github.com/naveen2513/roboshop-scripting.git",
      "cd roboshop-scripting",
      "sudo bash ${var.component_name}.sh ${var.password}",
    ]
  }
}


resource "aws_route53_record" "records" {
  zone_id = "Z04520141JRLZY4JX3O8T"
  name    = "${var.component_name}-dev.naveendevops1.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances.private_ip]
}
