data "aws_availability_zones" "available" {
  region = "us-east-1"
  state = "available"
  
}

data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}