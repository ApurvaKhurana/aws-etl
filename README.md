# AWS ETL - 
IaC setup for AWS VPC and related Network in AWS written in Terraform.

<img src="https://logodix.com/logo/1686050.png" height="32" width="32"> ![terraform version](https://img.shields.io/badge/terraform-v1.1.1-purple)

## Set up

### Prerequisites
 - AWS Account.

### Requirements
| Name | Version |
|------|---------|
| terraform | >= 1.1.0 |
| aws | >= 3.35 |

### Get terraform
```shell
wget https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
sudo apt-get install unzip
unzip terraform_1.1.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```
or 
```shell
brew install terraform # OS X 
```
### Get aws-cli
```shell
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version
```
Aws Cli Confiiguration:- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

## Usage
```shell
#clone this repo to your local
git clone git@github.com:ApurvaKhurana/aws-etl.git

#do ls to see 'aws-architecture' exists
ls

#switch to tf directory
cd aws-etl/resources

#initiate terraform
terraform init

#plan terraform
terraform plan

#apply terraform
terraform apply
```
## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr | The instance_type for compute environment to use | `string` | "10.0.0.0/16" | yes |
| vpc_tenancy | The ce_security_groups | `string` | default | yes |
| availability_zone | The ce_subnets | `string` | `ap-southeast-2a` | yes |
| public_subnet_cidr | The name of the job definitions | `string` | `10.0.1.0/24` | yes |
| private_subnet_cidr | Name of the service/pipeline | `string` | `10.0.2.0/24` | yes |
| key_name | key-pair to be assosiated with ec2 | `string` | n/a | no |
| instance_type | instance type for ec2 | `string` | "t2.micro" | yes |


## Outputs
| Name | Description |
|------|-------------|
| vpc_id | VPC ID of the vpc created |
| public_subnet_id | Subnet ID of public subnet |
| private_subnet_id | Subnet ID of private subnet |
| igw_id | ID of internet gateway assosiated with VPC |
| public_route_table_id | ID of public route table with a route to IGW |
| private_route_table_id | ID of private route table |
| public_ec2_instance_id | ID of public ec2 instance |
| private_ec2_instance_id | ID of private ec2 instance |


## Planned work/ TODOs :
 - [x] Separate Variables. 
 - [ ] Add security froups for ec2 resources. 


## Author
 - [Apurva Khurana](https://github.com/ApurvaKhurana) 
