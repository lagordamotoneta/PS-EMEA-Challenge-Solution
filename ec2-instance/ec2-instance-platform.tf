#--------------------------------------------------------------------------------
#---------------EC2 Instance-------------------------------------------
#--------------------------------------------------------------------------------

data "template_file" "installer" {
  #depends_on = [module.appd-aurora-database-cluster]
  template = file("./initializeArtifacts.sh")
  vars={
    db_endpoint = "${var.database_endpoint}"
  }
}

resource "aws_instance" "appd-platform" {
  
  ami                    = "ami-03ac5a9b225e99b02"
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [var.instance_sec_group_id]
  #user_data              = "${file("downloadInstaller.sh")}"
  user_data              = data.template_file.installer.rendered
  #user_data              = "#!/bin/bash \n lblblb > testfile.out \n sudo yum install curl \n curl -L -o \"/home/ec2-user/platform-setup-x64-linux-21.4.3.24599.sh\" -O https://download-files.appdynamics.com/download-file/enterprise-console/21.4.3.24599/platform-setup-x64-linux-21.4.3.24599.sh > curlResult.txt"
  
  
  # Copy in the bash script we want to execute.
  # The source is the location of the bash script
  # on the local linux box you are executing terraform
  # from.  The destination is on the new AWS instance.
   provisioner "file" {
    source      = "./installation.sh"
    destination = "/home/ec2-user/installation.sh"
  }

  #A licence file
  provisioner "file" {
    source      = "./license.lic"
    destination = "/home/ec2-user/license.lic"
  }
  # # Change permissions on bash script and execute from ec2-user.
  # provisioner "remote-exec" {
  #   inline = [
  #     "sed 's/serverHostName=/serverHostName=${self.private_dns}/'",
  #   ]
  # }
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ec2_key_file)
    host        = self.public_ip
  }
  
  root_block_device {
    volume_size = "32"
  }

  tags = {
    Component   = "EnterpriseConsole"
    Application = "AppDynamics"
  }

}


output "appd-platform_ip" {
  value = aws_instance.appd-platform.public_ip
}
output "appd-platform_public_dns" {
  value = aws_instance.appd-platform.public_dns
}

output "appd-platform_private_dns" {
  value = aws_instance.appd-platform.private_dns
}
output "appd-platform_private_ip" {
  value = aws_instance.appd-platform.private_ip
}

