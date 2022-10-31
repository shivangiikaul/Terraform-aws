variable "cidr_block" {
 
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
 
  type        = string
  default     = "10.0.0.0/24"
  
}
  

variable "az" {
 
  type        = string
  default     = "us-east-1a"
  
}

variable "subnet_cidr2" {
 
  type        = string
  default     = "10.0.1.0/24"
  
}

variable "az2" {

  type        = string
  default     = "us-east-1b"

}

