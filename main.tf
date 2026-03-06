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

resource "aws_subnet" "main" {
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