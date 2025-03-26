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
    Name        = "${var.name}-${var.env}-vpc"
    Environment = var.env
    Creator     = var.creator
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create public subnets by default 3 (Ireland A,B,C)
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.local_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.local_vpc.cidr_block, var.public_newbits, var.public_netnum + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Type        = "public"
    Name        = "${var.name}-${var.env}-public"
    Environment = var.env
    Creator     = var.creator
    Zone        = substr(element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create private subnets by default 3 (Ireland A,B,C)
resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.local_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.local_vpc.cidr_block, var.private_newbits, var.private_netnum + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Type        = "private"
    Name        = "${var.name}-${var.env}-private"
    Environment = var.env
    Creator     = var.creator
    Zone        = substr(element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Create Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.local_vpc.id

  tags = {
    Name        = "${var.name}-${var.env}-igw"
    Environment = var.env
    Creator     = var.creator
  }
}

# resource "aws_eip" "nat" {
#   count = var.nat_gateway_count
#   tags = {
#    Environment  = var.env
#    Creator      = var.creator
#   }
# }

# # Create NAT Gateway
# resource "aws_nat_gateway" "gw" {
#   count         = var.nat_gateway_count
#   allocation_id = element(aws_eip.nat.*.id, count.index)
#   subnet_id     = element(aws_subnet.public.*.id, count.index)
#   depends_on    = [aws_internet_gateway.default]
#   tags = {
#    Environment  = var.env
#    Creator      = var.creator
#   }
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.local_vpc.id

  tags = {
    Name        = "${var.name}${var.env}-public"
    Environment = var.env
    Creator     = var.creator
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
    Name        = "${var.name}-${var.env}-private"
    Environment = var.env
    Creator     = var.creator
    Zone        = substr(element(data.aws_availability_zones.available.names, count.index), -1, 1)
  }
}

# resource "aws_route" "private_to_inet" {
#   count                  = signum(var.nat_gateway_count) * var.private_subnet_count
#   route_table_id         = element(aws_route_table.private.*.id, count.index)
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = element(aws_nat_gateway.gw.*.id, count.index)
# }

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  count          = length(aws_subnet.public.*.id)
}

# resource "aws_route_table_association" "private" {
#   count          = "${length(aws_subnet.private.*.id)}"
#   route_table_id = element(aws_route_table.private.*.id, count.index)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
# }

resource "aws_vpc_dhcp_options" "options" {
  domain_name         = var.domain_name
  domain_name_servers = var.domain_name_servers
  tags = {
    Account     = var.name
    Environment = var.env
    Creator     = var.creator
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.local_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.options.id
}
