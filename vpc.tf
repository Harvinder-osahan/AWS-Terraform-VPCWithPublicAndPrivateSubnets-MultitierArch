provider "aws" {
  region = "ap-south-1"
  profile = "Harry"
}

resource "aws_vpc" "main" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  
tags = {
    Name = "VPCh"
  }
}

resource "aws_subnet" "pubsubnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "S1"
  }
}

resource "aws_subnet" "prisubnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "192.168.2.0/24"
  availability_zone = "ap-south-1b"
 
  tags = {
    Name = "S2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id     = "${aws_vpc.main.id}"
  
  tags = {
    Name = "myigw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id     = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
 
  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.pubsubnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.prisubnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sghmct3" {
  name        = "hmct3firewall"
  description = "Allow inbound traffic"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TCP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "wpin" {
  ami    = "ami-052c08d70def0ac62"
  instance_type = "t2.micro"
  key_name = "MyNewKey"
  vpc_security_group_ids = [aws_security_group.sghmct3.id]
  subnet_id  =  "${aws_subnet.pubsubnet.id}"
  connection {
    type   = "ssh"
    user   = "ec2-user"
    private_key = file("MyNewKey.pem")
    host      = aws_instance.wpin.public_ip   
  }
  tags = {
    Name = "WPOS"
  }
}



resource "aws_instance" "dbin" {
	ami = "ami-08706cb5f68222d09"
	instance_type = "t2.micro"
	key_name = "key1"
	vpc_security_group_ids = [aws_security_group.sghmct3.id]
        subnet_id = "${aws_subnet.prisubnet.id}"
   tags = {
          Name = "DBOS"
	  }
   }


