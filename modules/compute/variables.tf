variable "vpc_id" {}
variable "private_subnet_ids" {}
variable "app_sg_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami_id" {
  description = "AMI ID for web server"
  default = "ami-0ecb62995f68bb549" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type in us-east-1
}

variable "target_group_arn" {
  type = string
}
