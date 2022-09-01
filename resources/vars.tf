# vpc variables
variable "vpc_cidr" {
  description = "cidr range fro vpc"
  default     = "10.0.0.0/16"
}
variable "vpc_tenancy" {
  description = "instance tenancy"
  default     = "default"
}

//  required subnets and their configurations
variable "required_subnets" {
  description = "list of subnets required"
  default     = ["public-1a", "private-1a", "public-1b", "private-1b"]
}

variable "public_subnet_count" {
  default = 0
}

variable "subnet_conf" {
  type = map(any)
  default = {
    public-1a = {
      availability_zone = "us-east-1a"
      cidr              = "10.0.1.0/24"
    }
    private-1a = {
      availability_zone = "us-east-1a"
      cidr              = "10.0.2.0/24"
    }
    public-1b = {
      availability_zone = "us-east-1b"
      cidr              = "10.0.3.0/24"
    }
    private-1b = {
      availability_zone = "us-east-1b"
      cidr              = "10.0.4.0/24"
    }
    public-1c = {
      availability_zone = "us-east-1c"
      cidr              = "10.0.5.0/24"
    }
    private-1c = {
      availability_zone = "us-east-1c"
      cidr              = "10.0.6.0/24"
    }
  }
}

#ec2 variables
variable "key_name" {
  description = "key-pair to be used for ec2"
  default     = "virginia"
}
variable "instance_type" {
  description = "instance_type for ec2"
  default     = "t2.micro"
}

#sfn variables
variable "state_machine_name" {
  description = "name of data pipeline"
  default     = "myStateMachine"
}

variable "src_s3_bucket" {
}

variable "src_s3_path" {
}

variable "dest_s3_bucket" {
}

variable "dest_s3_path" {
}
   
variable "dd_table_name" {
}

variable "key1" {
}

variable "value1" {
}

