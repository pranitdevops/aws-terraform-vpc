resource "aws_vpc" "module" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags=merge(
      var.common_tags,
      var.vpc_tags,
      {
        Name=local.name
      }

      )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.module.id

  tags=merge(
      var.common_tags,
      var.igw_tags,
      {
        Name=local.name
      }

      )

}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.module.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
 tags=merge(
      var.common_tags,
      var.public_subnet_tags,
      {
        Name="${local.name}-public-${local.az_names[count.index]}" #roboshop-dev-public-us-east-1a
      }

      )
}


resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.module.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
 tags=merge(
      var.common_tags,
      var.private_subnet_tags,
      {
        Name="${local.name}-private-${local.az_names[count.index]}" #roboshop-dev-public-useast1a
      }

      )
}



resource "aws_subnet" "databse" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.module.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]
 tags=merge(
      var.common_tags,
      var.databse_subnet_tags,
      {
        Name="${local.name}-databse-${local.az_names[count.index]}" #roboshop-dev-public-useast1a
      }

      )
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ng" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
      var.common_tags,
      var.natgateway_tags,
      {
          Name="${local.name}"
      }
      )
  

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#for route table need only vpc for creation

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.module.id

   tags = merge(
      var.common_tags,
      var.public_route_table_tags,
      {
          Name="${local.name}-public"
      }
      )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.module.id

   tags = merge(
      var.common_tags,
      var.private_route_table_tags,
      {
          Name="${local.name}-private"
      }
      )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.module.id

   tags = merge(
      var.common_tags,
      var.database_route_table_tags,
      {
          Name="${local.name}-database"
      }
      )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ng.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ng.id
}

#route table association is nothing as subnet association so based on subnet count need to do association
resource "aws_route_table_association" "public" {
    count=length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public
}

resource "aws_route_table_association" "private" {
    count=length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private
}

resource "aws_route_table_association" "database" {
    count=length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database
}