# aws_vpc
# aws_internet_gateway
# aws_subnet_public
# aws_subnet_private
# aws_subnet_database
# aws_route_table_public
# aws_route_table_private
# aws_route_table_database
# aws_route--public(internet-gateway)
# aws_eip
# aws_nat_gateway
# aws_route--private(intranet[aws_nat_gatway])
# aws_route--database(intranet[aws_nat_gatway])
# aws_route_table_association_public
# aws_route_table_association_private
# aws_route_table_association_database



resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.igw_final_tags
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)  
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.azs_name[count.index]
  map_public_ip_on_launch = true   

 tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public-${local.azs_name[count.index]}"
    },
    var.public_subnet_tags
  )

}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs_name[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.azs_name[count.index]}"
    },
    var.private_subnet_tags
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs_name[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-${local.azs_name[count.index]}"
    },
    var.database_subnet_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-rt"
    },
    var.public_rt
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name= "${var.project}-${var.environment}-private-rt"
    },
    var.private_rt
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-rt"
    },
    var.database_rt
  )
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = ["0.0.0.0/0"]
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "main" {
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-eip"
    },
    var.eip_tags
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.public[0].id
  tags = merge(
    local.common_tags,
    {
      Name = "NAT-GatWay"
    },
    var.nat_tags
  )
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = ["0.0.0.0/0"]
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = ["0.0.0.0/0"]
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet_public[count.index].id
 route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route.private.id

}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route.database.id

}
