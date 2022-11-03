variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "testdb"
  sensitive   = true
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "test"
   sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "test1234"
   sensitive   = true
}

