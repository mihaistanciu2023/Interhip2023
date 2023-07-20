variable "instance_profile_name" {
    default = "SSMRole4EC2"
}

variable "sg_ingress_rules" {
  description = "List of sg_ingress_rules"
  default = null 
}

variable "name_prefix" { 
    default = "mihai-intership"
}


variable "network_remote_state_bucket" {

}
variable "network_remote_state_key" {
    default = "02-network.tfstate"
}
variable "region" {
    default = "eu-central-1"
}

variable "ami_id" { 
    default = "ami-06ca3ca175f37dd66"
}

variable "instance_type" {
    default = "t2.micro"
}