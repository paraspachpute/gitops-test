#!/bin/sh
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh

sudo mv kubectl-crossplane /root/bin
kubectl crossplane install configuration registry.upbound.io/xp/getting-started-with-aws:v1.10.1

AWS_PROFILE=default && echo -e "[default]\naws_access_key_id = $(aws configure get aws_access_key_id --profile $AWS_PROFILE)\naws_secret_access_key = $(aws configure get aws_secret_access_key --profile $AWS_PROFILE)" > creds.conf

kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt


kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf



rm creds.conf

kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-1.10/docs/snippets/configure/aws/providerconfig.yaml
