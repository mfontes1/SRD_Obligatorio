


# Se crean las instancias web1, DB y WAF

resource "aws_instance" "module-web1-instance-deploy" {
    instance_type          = var.instance_type
    key_name               = var.key_name
    ami                    = var.ami
    vpc_security_group_ids = [aws_security_group.web-SG.id,aws_security_group.efs-sg.id]
    subnet_id              = aws_subnet.pub_subnet1_obligatorio.id
    availability_zone      = var.vpc_aws_az


#verificar que el path de labsuser.pem coincida con el usuario que lo este ejecutando.
    provisioner "file" {
    source      = "playbook.yml"
    destination = "/home/admin/playbook.yml"

    connection {
      type = "ssh"
      user = "admin"
      private_key = file("/Users/marcio/Documents/ORT/Cloud/labsuser.pem")
      host = self.public_ip
    }
  }
    
    provisioner "remote-exec" {
      inline = [
      "sudo apt update -y",
      "sudo apt install ansible -y",
      "git clone https://github.com/jasodeep/ansible-lamp-stack-playbook.git /home/ubuntu/ansible-lamp",
      "git clone https://github.com/ansible-lockdown/DEBIAN11-CIS.git /home/ubuntu/debian11-cis",
    #  "sudo ansible-playbook /admin/ubuntu/ansible-lamp/site.yml",
    #  "sudo ansible-playbook /admin/ubuntu/debian11-cis/site.yml"       
        
  ] 
  connection {
      type = "ssh"
      user = "admin"
      private_key = file("/Users/marcio/Documents/ORT/Cloud/labsuser.pem")
      host = self.public_ip
    }
}  




tags = {
        Name = var.name_instance
    }
}

 