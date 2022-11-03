module "networking" {
  source    = "./modules/networking"
}

module "ec2" {
  source     = "./modules/ec2"
#  vpc        = module.networking.vpc
  
}

module "RDS" {
  source    = "./modules/RDS"
  vpc_security_group_ids = [module.SECURITY-GROUPS.test-db-sg-id]
  subnet_ids = ["${module.networking.test-subnet}", "${module.networking.test-subnet2}"]
}

module "IAM" {
  source    = "./modules/IAM"
}

module "SECURITY-GROUPS" {
  source    = "./modules/SECURITY-GROUPS"
}


