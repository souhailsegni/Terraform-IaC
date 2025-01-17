variable "cidr_block" {
    description="CIDR block for the VPC."
    type        = string
}

variable "name" {
    description="Name of the VPC."
    type        = string
}

variable "public_subnet_cidrs" {
    description="List of CIDR blocks for public subnets."
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description="List of CIDR blocks for private subnets."
    type        = list(string)
}

variable "availability_zones" {
    description="List of availability zones."
    type        = list(string)
}

variable "public_subnet_count" {
    description="Number of public subnets."
    type        = number
}

variable "private_subnet_count" {
    description="Number of private subnets."
    type        = number
}

variable "http_port" {
    description="HTTP port."
    default=80 
}

variable "https_port" {
    description="HTTPS port."
    default=443 
}

variable "protocol" {
    description="Protocol (tcp)."
    default="tcp"
}
