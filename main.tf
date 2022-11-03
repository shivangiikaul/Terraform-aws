module "networking" {
  source    = "./modules/networking"
}

module "ec2" {
  source     = "./modules/ec2"
#  vpc        = module.networking.vpc
}

module "RDS" {
  source    = "./modules/RDS"
#  depends_on = [module.networking]
#  db-subnet =  module.networking.test-subnet
}

module "IAM" {
  source    = "./modules/IAM"
}

module "SECURITY-GROUPS" {
  source    = "./modules/SECURITY-GROUPS"
}


