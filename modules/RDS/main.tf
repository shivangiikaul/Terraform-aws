
module "networking" {
 source = "../networking"
 }

module "SECURITY-GROUPS" {
 source = "../SECURITY-GROUPS"
 }

resource "aws_db_instance" "test-database" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
  vpc_security_group_ids = ["${module.networking.test-db-sg-id}"]
#  depends_on = [module.networking]
}

resource "aws_db_subnet_group" "db-subnet" {
 name = "db_subnet_group"
 subnet_ids = ["${module.networking.test-subnet}", "${module.networking.test-subnet2}"]
}
