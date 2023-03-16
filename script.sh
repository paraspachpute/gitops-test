#!/bin/bash

#parse env-list.yaml
# env_list="./env-list.yaml"
# env_names=($(yq -r '.env[]' $env_list))
git checkout master

git checkout -b template

for env in $(yq eval '.env[].name' env-list.yaml); do
  name=$(yq eval ".env[] | select(.name == \"$env\") | .name" env-list.yaml)
  account_id=$(yq eval ".env[] | select(.name == \"$env\") | .account_id" env-list.yaml)
  region=$(yq eval ".env[] | select(.name == \"$env\") | .region" env-list.yaml)
  vpc_id=$(yq eval ".env[] | select(.name == \"$env\") | .vpc_id" env-list.yaml)
  subnet1=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-1" env-list.yaml)
  subnet2=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-2" env-list.yaml)
  subnet3=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-3" env-list.yaml)
  key_id=$(yq eval ".env[] | select(.name == \"$env\") | .key_id" env-list.yaml)
  cluster_oidc_id=$(yq eval ".env[] | select(.name == \"$env\") | .cluster_oidc_id" env-list.yaml)
  security_group_id=$(yq eval ".env[] | select(.name == \"$env\") | .security_group_id" env-list.yaml)
  opensearch_vpc_endpoint=$(yq eval ".env[] | select(.name == \"$env\") | .opensearch_vpc_endpoint" env-list.yaml)

  echo "$env,$name,$account_id,$region,$vpc_id,$subnet1,$subnet2,$subnet3,$key_id,$cluster_oidc_id,$security_group_id,$opensearch_vpc_endpoint"
  
  # git branch -d $env 2>/dev/null # the branch test doesn't exists
  git branch # list all branches 
  # git branch 
  git checkout -b $env # creates a new branch named $env based on the contents of the template branch
  # git checkout $env
  echo $PWD
  cd workload-config/infrastructure/
  echo $PWD
  # git push -u origin $env
  find . -type f -name '*.yaml' -exec sed -i "s/ENV_NAME/$name/g" {} + # unable to understand this command
  find . -type f -name '*.yaml' -exec sed -i "s/ACCOUNT_ID/$account_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/REGION/$region/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/VPC_ID/$vpc_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_1/$subnet1/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_2/$subnet2/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_3/$subnet3/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/KEY_ID/$key_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SECURITY_GROUP_ID/$security_group_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/CLUSTER_OIDC_ID/$cluster_oidc_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/OPENSEARCH_VPC_ENDPOINT/$opensearch_vpc_endpoint/g" {} +

  # git add .
  # git commit -m "ENV_NAME replaced with $env"
  # git push
  cd ../..
  git checkout template
done

# echo "$env,$name,$account_id,$region,$vpc_id,$subnet1,$subnet2,$subnet3,$key_id,$cluster_oidc_id,$security_group_id,$opensearch_vpc_endpoint"

# Go to mgmt-repo folder
# cd dev-infra-flux-ack

# check if git is clean
# if [[ $(git status --porcelain) ]]; then
#   echo "Error: git status is not clean. Please commit or stash your changes before running this script."
#   echo $(git status --porcelain)
#   echo $(git status)
#   exit 1
# fi

# # switch to master branch
# git checkout master

# # checkout to template branch 
# git checkout -b template # switch to template branch even if it isnt created


# # #Delete branches which are not in env-list.yaml
# # Get list of all branches
# # all_branches=($(git branch -a | awk -F "/" '{print $NF}'))

# # # Iterate over all branches
# # for branch in "${all_branches[@]}"; do
# #   # If the branch is not in env_names and not master or template, delete the branch
# #   if [[ ! " ${env_names[@]} " =~ " ${branch} " ]] && [[ $branch != "master" ]] && [[ $branch != "template" ]]; then
# #     git branch -D $branch
# #   fi
# # done

# # Iterate over the array and create new branches
# for env in "${env_names[@]}"; do
#   git branch -d $env 2>/dev/null # the branch test doesn't exists
#   git branch # list all branches 
#   # git branch 
#   git branch $env template # creates a new branch named $env based on the contents of the template branch
#   git checkout $env
#   cd ./workload-config/infrastructure/
#   echo $pwd
#   # git push -u origin $env
#   find . -type f -name '*.yaml' -exec sed -i "s/ENV_NAME/$name/g" {} + # unable to understand this command
#   find . -type f -name '*.yaml' -exec sed -i "s/ACCOUNT_ID/$account_id/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/REGION/$region/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/VPC_ID/$vpc_id/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_1/$subnet1/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_2/$subnet2/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_3/$subnet3/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/KEY_ID/$key_id/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/SECURITY_GROUP_ID/$security_group_id/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/CLUSTER_OIDC_ID/$cluster_oidc_id/g" {} +
#   find . -type f -name '*.yaml' -exec sed -i "s/OPENSEARCH_VPC_ENDPOINT/$opensearch_vpc_endpoint/g" {} +

#   # git add .
#   # git commit -m "ENV_NAME replaced with $env"
#   # git push
#   git checkout master

# done

