output "azs" {
  value = data.aws_availability_zones.azs.names #i want only  first 2 names
}

output "vpc_id" {
  value=aws_vpc.module.id
}

output "public_subnets_id" {
  value=aws_subnet.public[*].id
}

output "private_subnets_id" {
  value=aws_subnet.private[*].id
}

output "database_subnets_id" {
  value=aws_subnet.database[*].id
}