# Default provider (eu-north-1)
provider "aws" {
  region = "eu-north-1"

  assume_role {
    role_arn     = "arn:aws:iam::1234567890:role/RemoteAdministrator"
    session_name = "VASYA_SIN_SESSION"
  }
}

# Additional provider (us-east-1)
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

# Additional provider (eu-central-1)
provider "aws" {
  alias  = "ger"
  region = "eu-central-1"
}

# Get latest Amazon Linux 2 AMIs from SSM
data "aws_ssm_parameter" "ami_eu_north" {
  name   = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "ami_us_east" {
  provider = aws.us
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "ami_eu_central" {
  provider = aws.ger
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2 in default region (eu-north-1)
resource "aws_instance" "europe_server" {
  ami           = data.aws_ssm_parameter.ami_eu_north.value
  instance_type = "t3.micro"

  tags = {
    Name = "Europe Server"
  }
}

# EC2 in us-east-1
resource "aws_instance" "us_server" {
  provider      = aws.us
  ami           = data.aws_ssm_parameter.ami_us_east.value
  instance_type = "t3.micro"

  tags = {
    Name = "US Server (East)"
  }
}

# EC2 in eu-central-1
resource "aws_instance" "german_server" {
  provider      = aws.ger
  ami           = data.aws_ssm_parameter.ami_eu_central.value
  instance_type = "t3.micro"

  tags = {
    Name = "German Server"
  }
}
