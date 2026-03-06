locals {
  common_tags = {
    Project = "Roboshop"
    Environment = "Dev"
    Terraform = "true"
  }
  vpc_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-vpc"
    },
    var.vpc_tags
  )
  igw_final_tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-ig"
    },
    var.igw_tags
  )
  azs_name = slice(data.aws_availability_zones.available.name, 0 , 2)
  
  
}