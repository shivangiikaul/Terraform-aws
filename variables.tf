variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "test-db"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "test"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "test@1234"
}
