

provider "aws"{

	region = "us-east-1"

}

#step 1 : create a vpc

resource  "aws_vpc" "prod-vpc"{

    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Production VPC"
    }

}

#step 2 : create internet gateway

resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "main"
  }
}

#step 3 : create custom routing table

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "routing table"
  }
}


#step 4 : create subnet

resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "production subnet"
  }
}



#step 5 : associate subnet with the route table

resource "aws_route_table_association" "a" {

  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.route-table.id

}

#step 6 : create security group to allow ports 22 443 and 80


resource "aws_security_group" "security_group_main" {
  name   = "security group"
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#step 7 : create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "network_interface" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.security_group_main.id]

}


#step 8 : assign an elastic ip to the network interface that was created in step 7

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.network_interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on =[ aws_internet_gateway.gw]
}

#step 9 : create ubuntu server and install/enable a web server.

resource "aws_instance" "web-server-instance" {

    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "main-key"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.network_interface.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo This is my very first web server that i am going to test > /var/www/html/index.html'
                EOF

    tags =  {
        Name = "web-server"
    }
}
