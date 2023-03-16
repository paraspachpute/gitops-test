source: https://aws.amazon.com/blogs/containers/leverage-aws-secrets-stores-from-eks-fargate-with-external-secrets-operator/

create IAM OIDC provider for the cluster to enable IRSA 
eksctl utils associate-iam-oidc-provider --cluster=dev-management --approve