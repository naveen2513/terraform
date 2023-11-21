
resource "aws_instance" "instances" {
  for_each               = var.components
  ami                    = data.aws_ami.ami.image_id
  instance_type          = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }
}
resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instances,aws_route53_record.records]
  for_each = var.components
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = "DevOps321"
      host     = aws_instance.instances[each.value["name"]].private_ip
    }
    inline = [
      "rm -rf roboshop-scripting",
      "git clone https://github.com/naveen2513/roboshop-scripting",
      "cd roboshop-scripting",
      "sudo bash ${each.value["name"]} ${lookup(each.value,"password" "null" )}"
    ]
  }
}


resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z04520141JRLZY4JX3O8T"
  name    = "${each.value["name"]}-dev.naveendevops1.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instances[each.value["name"]].private_ip]
}
