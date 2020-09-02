provider "aws" {
  region     = "ap-south-1"
  profile    = "pranaliaws"
}

// --------creating Security Group------------


resource "aws_security_group" "nfssg" {
  name        = "nfssg"
  vpc_id     = "vpc-9de0fdf5"
  ingress {
    protocol   = "tcp"
    from_port  = 2049
    to_port    = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  
  }
}

// ------------Instance----------

resource "aws_instance" "taskinstance" {
  depends_on = [ aws_security_group.nfssg,
		]

  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name = "mykey1111"
  security_groups = [ "nfssg" ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Lenovo/Downloads/mykey1111")
    host     = aws_instance.taskinstance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  php git -y",
      "sudo yum install amazon-efs-utils -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
      
    ]
  }

  tags = {
    Name = "pranalios"
  }

}


