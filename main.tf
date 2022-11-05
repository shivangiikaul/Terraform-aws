module "networking" {
  source    = "./modules/networking"
}

module "ec2" {
  source     = "./modules/ec2"
#  vpc        = module.networking.vpc
  test-sg-id = [module.SECURITY-GROUPS.test-sg-id]
  test-profile-name =  module.IAM.test-profile-name
  test-subnet = [ module.networking.test-subnet, module.networking.test-subnet2 ]
  test-targetgroups = module.LB.test-targetgroups 
  
}

module "RDS" {
  source    = "./modules/RDS"
  db-sg-id  = [module.SECURITY-GROUPS.test-db-sg-id]
  test-subnet  = ["${module.networking.test-subnet}", "${module.networking.test-subnet2}"]
}

module "IAM" {
  source    = "./modules/IAM"
}

module "SECURITY-GROUPS" {
  source    = "./modules/SECURITY-GROUPS"
  vpc-id = module.networking.vpc-id 
}

module "LB" {
 source = "./modules/LB"
 vpc-id = module.networking.vpc-id
 test-sg-elb-id = [module.SECURITY-GROUPS.test-sg-elb-id]
 test-subnet =  ["${module.networking.test-subnet}", "${module.networking.test-subnet2}"]
 }
