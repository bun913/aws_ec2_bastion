resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "db" {
  for_each          = { for sb in var.db_subnets : sb.name => sb }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, { "Name" : "${var.prefix}-${each.value.name}" })
}

resource "aws_subnet" "public" {
  for_each          = { for sb in var.public_subnets : sb.name => sb }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, { "Name" : "${var.prefix}-${each.value.name}" })
}

resource "aws_subnet" "private" {
  for_each          = { for sb in var.private_subnets : sb.name => sb }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, { "Name" : "${var.prefix}-${each.value.name}" })
}
# PatchManagerで更新を取得するためにNATが必要
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_eip" "nat_gateway" {
  count = 2
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = 2
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public["${var.public_subnets[count.index].name}"].id
  tags = {
    Name = "${var.prefix}-nat"
  }

  depends_on = [aws_internet_gateway.main]
}

# プライベートサブネット用ルートテーブル
# プライベートサブネットからNatGateywayへのルートを作る
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.prefix}-route-private" }, var.tags)
}

resource "aws_route" "private" {
  count                  = 2
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private["${var.private_subnets[count.index].name}"].id
  route_table_id = aws_route_table.private[count.index].id
}

# パブリックサブネット用ルートテーブル
# Natが配置されるパブリックサブネットからIGWへのルートを作る
resource "aws_route_table" "public" {
  count  = 2
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" : "${var.prefix}-route-public" }, var.tags)
}

resource "aws_route" "public" {
  count                  = 2
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public["${var.public_subnets[count.index].name}"].id
  route_table_id = aws_route_table.public[count.index].id
}
