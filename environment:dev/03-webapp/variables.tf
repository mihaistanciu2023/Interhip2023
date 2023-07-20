variable "remote_state_bucket" {
    default = "milestone-mihai-bucket"
}

variable "dynamodb_table" {
    default = "milestone-mihai-locks"
}

variable "name_prefix" { 
    default = "milestone-mihai"
}