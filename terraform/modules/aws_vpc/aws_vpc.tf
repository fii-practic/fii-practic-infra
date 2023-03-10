/*
--------------------------------------------------------------
Default VPC Template
Ireland, availability zone A,B,C
Subnbets:
- <public-a> | <public-b> | <public-c>
- <private-a> | <private-b> | <private-c>
--------------------------------------------------------------
*/

# Get the availability zones of the AWS Accoout that uses this vpc module (currently Ireland A, B, C)
data "aws_availability_zones" "available" {}


resource "aws_vpc" "local_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name    = "${var.name}-vpc"
    Creator = "Managed by Terraform"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create public subnets by default 3 (Ireland A,B,C)
resource "aws_subnet" "public" {
  count =  length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.local_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.local_vpc.cidr_block, var.public_newbits, var.public_netnum + count.index)
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Type         = "public"
    Name         = "${var.name}-public"
    Creator      = "Managed by Terraform"
    Zone = substr( element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create private subnets by default 3 (Ireland A,B,C)
resource "aws_subnet" "private" {
  count =  length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.local_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.local_vpc.cidr_block, var.private_newbits, var.private_netnum + count.index)
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Type         = "private"
    Name         = "${var.name}-private"
    Creator      = "Managed by Terraform"
    Zone         = substr(element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.local_vpc.id

  tags = {
    Creator = "Managed by Terraform"
  }
}

//resource "aws_security_group" "nat_vpn_instance_sg" {
//  name        = "nat-instance-sg"
//  description = "Allow trafic to and from nat instance"
//  vpc_id      = aws_vpc.local_vpc.id
//
//  ingress {
//    from_port = 22
//    protocol  = "tcp"
//    to_port   = 22
//    cidr_blocks = var.trusted_cidrs
//    description = "SSH acess from IC appartment"
//  }
//
//  ingress {
//    from_port = 1194
//    protocol  = "udp"
//    to_port   = 1194
//    cidr_blocks = ["0.0.0.0/0"]
//    description = "Used by your clients to initiate UDP based VPN sessions to the VPN server"
//  }
//
//  ingress {
//    from_port = 81
//    protocol  = "tcp"
//    to_port   = 81
//    cidr_blocks = ["0.0.0.0/0"]
//    description = "Used by OpenVPN Access Server for the Client Web Server"
//  }
//
//  ingress {
//    from_port = 80
//    protocol  = "tcp"
//    to_port   = 80
//    cidr_blocks = ["0.0.0.0/0"]
//    description = "Used by Lets Encrypt bot"
//  }
//
//  ingress {
//    from_port = 0
//    protocol  = "-1"
//    to_port   = 0
//    cidr_blocks = [var.cidr_block]
//    description = "Allow trafic inbound from all aws subnets"
//  }
//
//  egress {
//    from_port = 0
//    protocol = "-1"
//    to_port = 0
//    cidr_blocks = ["0.0.0.0/0"]
//  }
//}

//resource "aws_instance" "nat_vpn_instance" {
//  ami                         = var.ami_id
//  instance_type               = "t3.micro"
//  key_name                    = aws_key_pair.iconstantinescu.id
//  associate_public_ip_address = true
//  source_dest_check           = false
//  subnet_id                   = aws_subnet.public.0.id
//  depends_on                  = [aws_internet_gateway.default, aws_security_group.nat_vpn_instance_sg]
//  vpc_security_group_ids      = [aws_security_group.nat_vpn_instance_sg.id]
//  disable_api_termination     = true
//
//  root_block_device {
//    volume_type = "gp2"
//    delete_on_termination = true
//    volume_size = 20
//  }
//
//  credit_specification {
//    cpu_credits = "standard"
//  }
//
//  tags = {
//    Name    = var.name
//    Creator = "Managed by Terraform"
//  }
//
//  connection {
//    user        = "clearos"
//    private_key = file(var.private_key_path)
//    host        = "vpn.example.com"
//  }
//
//  provisioner "remote-exec" {
//    inline = [
//      "sudo echo 'nat-vpn.fiipractic.com' > /etc/hostname",
//      "sudo yum upgrade -y && sudo init 6"
//    ]
//  }
//}

//resource "aws_route53_record" "nat_vpn_instance" {
//  zone_id = var.route53_zone_id
//  name    = "vpn."
//  type    = "A"
//  ttl     = "300"
//  records = [aws_instance.nat_vpn_instance.public_ip]
//}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.local_vpc.id

  tags = {
    Name         = "${var.name}-public"
    Creator      = "Managed by Terraform"
  }
}

resource "aws_route" "public_to_inet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.local_vpc.id

  tags = {
    Name         = "${var.name}-private"
    Creator      = "Managed by Terraform"
    Zone = substr(element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }
}

# resource "aws_route" "private_to_inet" {
#   count                  = signum(var.nat_gateway_count) * var.private_subnet_count
#   route_table_id         = element(aws_route_table.private.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   instance_id            = var.nat_vpn_instance
# }

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  count = "${length(aws_subnet.public.*.id)}"
}

# resource "aws_route_table_association" "private" {
#   route_table_id = element(aws_route_table.private.*.id, count.index)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   count = "${length(aws_subnet.private.*.id)}"
# }

resource "aws_vpc_dhcp_options" "options" {
  domain_name         = var.domain_name
  domain_name_servers = var.domain_name_servers
  tags = {
    Account      = var.name
    Creator      = "Managed by Terraform"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.local_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.options.id
}
