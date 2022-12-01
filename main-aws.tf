data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "vm_aws_01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "aws_key" 
  subnet_id = var.subnet_public_id
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/root/aws/aws_key")
      timeout     = "4m"
   }

  provisioner "remote-exec" {
    script = "scripts/script-vm-aws.sh"
  }

  tags = {
    Name = "vm-aws"
  }
}

resource "aws_instance" "vm_aws_02" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "aws_key"
  subnet_id = var.subnet_public_id
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/root/aws/aws_key")
      timeout     = "4m"
   }

  provisioner "remote-exec" {
    script = "scripts/script-vm-aws-02.sh"
  }

  tags = {
    Name = "vm-aws-02"
  }
}



resource "aws_security_group" "permitir_ssh_http" {
  name        = "permitir_ssh"
  description = "Permite SSH e HTTP na instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP 8080 to EC2"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "permitir_ssh_e_http"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYCLsnkSyNlem2JgiICBpAZ4GBVsUoNkR2fQFo8U3d2Pks+eBycsxhHq2IgJIdcrJ8g1PtRkfr10QIgSbOu6jY2y4nvskRyYDbDURTf4pHNH13nj159VkZGDmQTPqYNbJvx5WOsUjuoFRoJeEo/vWKIDsXJigR/djhUuJ6/Bk5SviHLTgJkfMisJAVGCdRnN09VAQ8PpizCPdlVYIW6S4iwt3uIqyqq9uKcH58VNaO0v47hQ02im7xCq8fixjy+CgKRO2KK0P/WiAmRSNQ94yajuAHIVZ6kJqSUpCoUN7XD6SG1RHW2STezYnHunZ5pW8JaZ3cIw4D9Fz6mlsS12CV root@vm-iac-01"
}

resource "aws_s3_bucket" "bucket_atividade" {
    bucket = "atividade-iac-mackenzie-bucket002" 
}
