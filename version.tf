data "aws_ami" "amazon-2" {
    most_recent = true
  
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
    owners = ["amazon"]
  }
 
#create ec2 instances 

resource "aws_instance" "jenkinsInstance" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = aws_key_pair.jenkins_key.key_name
  user_data              = file("install.sh")
 
  tags = {
    Name = "jenkins instance"
  }
}

resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits = "2048"

}

resource "aws_key_pair" "jenkins_key" {
  key_name = "privatekeypair"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

resource "local_file" "ssh_key" {
    filename = "keypair.pem"
    content = tls_private_key.jenkins_key.private_key_pem
  
}

output "ssh-command" {
  value = "ssh -i keypair.pem ec2-user@${aws_instance.jenkinsInstance.public_dns}"
}

output "public-IP" {
    value = aws_instance.jenkinsInstance.public_ip
}