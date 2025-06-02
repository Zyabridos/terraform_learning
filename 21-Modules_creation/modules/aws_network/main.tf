#----------------------------------------------------------
# My Terraform

#  Что делает код:
#  - собственная сеть (VPC),
#  - выход в интернет (через Internet Gateway и NAT),
#  - две группы подсетей:
#    - публичные (видны из интернета),
#    - приватные (без прямого доступа из интернета, но могут сами выходить в интернет через NAT).
#----------------------------------------------------------

#==============================================================

data "aws_availability_zones" "available" {}

# Создает собственную сеть (VPC) с заданным IP-диапазоном (var.vpc_cidr), 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

# Создает интернет-шлюз, чтобы дать внешний доступ публичным подсетям.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}

#-------------Public Subnets and Routing----------------------------------------

# Создает несколько публичных подсетей, по одной в каждой AZ.
# Эти подсети получат внешний IP при запуске EC2-инстанса (map_public_ip_on_launch = true).

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

# Создает таблицу маршрутов, которая говорит:
# "весь трафик наружу (0.0.0.0/0) — через Internet Gateway".

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

# resource "aws_route_table_association" "public_routes" {...}
# Привязывает каждую подсеть к таблице маршрутов выше.

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}


#-----NAT Gateways with Elastic IPs--------------------------

# Создает внешние IP-адреса (Elastic IP) — они понадобятся NAT-шлюзам.
resource "aws_eip" "nat" {
  count   = length(var.private_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}

# Создает NAT-шлюзы в публичных подсетях, чтобы приватные подсети могли выйти в интернет
# (например, установить пакеты), но были недоступны из интернета.

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}


#--------------Private Subnets and Routing-------------------------

# Создает приватные подсети в каждой AZ.
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-private-${count.index + 1}"
  }
}


# Создает таблицы маршрутов для приватных подсетей:
# весь внешний трафик идет через NAT-шлюз.

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-private-subnet-${count.index + 1}"
  }
}

# Привязывает приватные подсети к соответствующим таблицам маршрутов.

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}

#==============================================================