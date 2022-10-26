#!/usr/bin/bash

set -xe
#create iam groups
aws iam create-group --group-name Admins
#list user-groups 
aws iam list-groups
#attach full admin policy to group 
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --group-name Admins
#attach policies attached to a group 
aws iam  list-attached-group-policies --group-name Admins
# create user 
aws iam create-user --user-name shivangi --tags '{"Key": "created-by", "Value": "shivangi"}'
#add user to group 
aws iam add-user-to-group --user-name shivangi --group-name  Admins 

