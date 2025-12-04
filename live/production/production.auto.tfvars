vpc_cidr = "10.3.0.0/16"

public_subnets = [
  {
    cidr_block        = "10.3.0.0/24"
    availability_zone = "ap-south-1a"
  },
  {
    cidr_block        = "10.3.1.0/24"
    availability_zone = "ap-south-1b"
  },
  {
    cidr_block        = "10.3.2.0/24"
    availability_zone = "ap-south-1c"
  },
]

private_subnets = [
  {
    cidr_block        = "10.3.64.0/18"
    availability_zone = "ap-south-1a"
  },
  {
    cidr_block        = "10.3.128.0/18"
    availability_zone = "ap-south-1b"
  },
  {
    cidr_block        = "10.3.192.0/18"
    availability_zone = "ap-south-1c"
  },
]