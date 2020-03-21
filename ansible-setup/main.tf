# creation of VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  tags {
        Name = "terraform-aws-vpc"
    }
}

# creation of subnet
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

# create a internet gateway
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}


# Add a route table

resource "aws_route_table" "us-east-1-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
    tags {
        Name = "Public_rt"
    }
}
resource "aws_route_table_association" "us-east-1-public" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa <public_key>"
}

resource "aws_instance" "myserver" {
  ami           = "ami-0c322300a1dd5dc79"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  subnet_id     = "${aws_subnet.main.id}"
  key_name      = "${aws_key_pair.deployer.key_name}"
  associate_public_ip_address = true


  tags = {
    Name = "ansible-server"
  }
}

resource "null_resource" "httpd" {
  # Changes to any instance of the cluster requires re-provisioning
  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = "${aws_instance.myserver.public_ip}"
    user = "ec2-user"
    private_key = "${file(var.private_key)}"
    type  = "ssh"

  }
  provisioner "file" {
    source      = "<path>/init.sh"
    destination = "<destination_path>/init.sh"
  }
 provisioner "remote-exec" {
    inline = [
      "sudo chmod +x <destination_path>/init.sh",
      "sudo <destination_path>/init.sh",
    ]
  }
}

