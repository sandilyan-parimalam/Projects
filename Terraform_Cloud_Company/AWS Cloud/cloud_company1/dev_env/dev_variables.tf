variable "region" {
  default = "us-east-1"
}

variable "budget_limit_amount" {
  default = "10.0"
}

variable "budget_limit_unit" {
  default = "USD"
}

variable "budget_time_unit" {
  default = "MONTHLY"
}

variable "budget_time_period_start" {
  default = "2023-11-09_00:01"
}

variable "budget_type" {
  default = "COST"
}

variable "budget_name" {
  default = "devops_budget"
}


variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "vpc_name" {
  default = "dev_vpc"
}

variable "web_subnet_cidr_block" {
  default = "10.10.1.0/24"
}

variable "web_subnet_name" {
  default = "dev_web_subnet"
}

variable "web_subnet_1_cidr_block" {
  default = "10.10.2.0/24"
}

variable "web_subnet_1_name" {
  default = "dev_web_1_subnet"
}
variable "web_subnet_az" {
  default = "us-east-1a"
}
variable "web_subnet_1_az" {
  default = "us-east-1b"
}

variable "internet_gateway_name" {
  default = "dev_web_igw"
}

variable "route_table_name" {
  default = "dev_web_rt"
}

variable "route_table_association_name" {
  default = "dev_web_rt_association"
}

variable "security_group_name" {
  default = "dev_web_sg"
}

variable "security_group_description" {
  default = "Security Group for Dev Web environment"
}

variable "ssh_ingress_description" {
  default = "all ssh traffic from internet"
}

variable "ssh_ingress_from_port" {
  default = "22"
}

variable "ssh_ingress_to_port" {
  default = "22"
}

variable "ssh_ingress_protocol" {
  default = "tcp"
}

variable "ssh_ingress_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "any_source_cidr_block" {
  default = "0.0.0.0/0"
}

variable "web_server_instance_ami" {
  default = "ami-05c13eab67c5d8861"
}

variable "web_server_instance_type" {
  default = "t2.micro"
}


variable "web_server_instance_key_name" {
  default = "dev_web_keypair"
}

variable "web_server_instance_tags" {
  default = {
    Name = "DLW01"
  }
}

variable "dev_web_eks_iam_role" {
  default = "dev_web_eks_iam_role"
}
variable "dev_web_eks_iam_policy_attachment" {
  default = "dev_web_eks_iam_policy_attachment"
}
variable "dev_web_eks_iam_policy_attachment1" {
  default = "dev_web_eks_iam_policy_attachment1"

}
variable "dev_web_eks_node_iam_role" {
  default = "dev_web_eks_node_iam_role"

}
variable "dev_web_eks_node_iam_policy_attachment" {
  default = "dev_web_eks_node_iam_policy_attachment"
}
variable "dev_web_eks_node_iam_policy_attachment1" {
  default = "dev_web_eks_node_iam_policy_attachment1"
}
variable "dev_web_eks_node_iam_policy_attachment2" {
  default = "dev_web_eks_node_iam_policy_attachment2"
}
variable "dev_web_eks_node_iam_policy_attachment3" {
  default = "dev_web_eks_node_iam_policy_attachment3"
}

variable "dev_web_eks_cluster" {
  default = "dev_web_eks_cluster"
}

variable "dev_web_eks_node_group" {
  default = "dev_web_eks_node_group"
}