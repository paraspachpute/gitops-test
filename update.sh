#!/bin/bash

git checkout template

ls
pwd
ls -al

env_list="/mnt/c/Users/HP/Desktop/Flairminds/Vinculum/DevOps/gitops-test/flux-infra-management/env-list.yaml"
env_names=($(yq -r '.env[].name' $env_list))

# Check if git is clean
if [[ $(git status --porcelain) ]]; then
  echo "Error: git status is not clean. Please commit or stash your changes before running this script."
  echo $(git status --porcelain)
  echo $(git status)
  exit 1
fi


# Iterate over all environments in the env-list.yaml file
for env in "${env_names[@]}"; do
  # Get the values of the current environment
  name=$(yq eval ".env[] | select(.name == \"$env\") | .name" $env_list)
  account_id=$(yq eval ".env[] | select(.name == \"$env\") | .account_id" $env_list)
  region=$(yq eval ".env[] | select(.name == \"$env\") | .region" $env_list)
  vpc_id=$(yq eval ".env[] | select(.name == \"$env\") | .vpc_id" $env_list)
  subnet1=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-1" $env_list)
  subnet2=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-2" $env_list)
  subnet3=$(yq eval ".env[] | select(.name == \"$env\") | .subnet-3" $env_list)
  key_id=$(yq eval ".env[] | select(.name == \"$env\") | .key_id" $env_list)
  cluster_oidc_id=$(yq eval ".env[] | select(.name == \"$env\") | .cluster_oidc_id" $env_list)
  security_group_id=$(yq eval ".env[] | select(.name == \"$env\") | .security_group_id" $env_list)
  opensearch_vpc_endpoint=$(yq eval ".env[] | select(.name == \"$env\") | .opensearch_vpc_endpoint" $env_list)

  echo "$env,$name,$account_id,$region,$vpc_id,$subnet1,$subnet2,$subnet3,$key_id,$cluster_oidc_id,$security_group_id,$opensearch_vpc_endpoint"

  # Create a new branch for the current environment
  git checkout -b $env
  git checkout $env
  git branch -a
  git status

  ls
  pwd
  ls -al
  # Update the environment variables in the YAML files
  cd workload-config/infrastructure/
  find . -type f -name '*.yaml' -exec sed -i "s/ENV_NAME/$name/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/ACCOUNT_ID/$account_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/REGION/$region/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/VPC_ID/$vpc_id/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_1/$subnet1/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_2/$subnet2/g" {} +
  find . -type f -name '*.yaml' -exec sed -i "s/SUBNET_3/$subnet3/g" {} +
  find . -type f -name '.yaml' -exec sed -i "s/KEY_ID/$key_id/g" {} +
  find . -type f -name '.yaml' -exec sed -i "s/CLUSTER_OIDC_ID/$cluster_oidc_id/g" {} +
  find . -type f -name '.yaml' -exec sed -i "s/SECURITY_GROUP_ID/$security_group_id/g" {} +
  find . -type f -name '.yaml' -exec sed -i "s/OPENSEARCH_VPC_ENDPOINT/$opensearch_vpc_endpoint/g" {} +
  
  git add .
  git status
  git commit -m "Update environment variables for $env"
  git push -u origin $env
  git status
  git branch -a
  git checkout template
done
