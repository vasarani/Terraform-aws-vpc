output "azs_info" {
  value = data.aws_availability_zones.available
}

output "aws_vpc_peering_connection" {
  value = aws_vpc_peering_connection.default.id
}