data "aws_availability_zones" "available" {
  region = "us-east-1"
  state = "available"
  
}