terraform-ssm-ansible-example
=============================

An example on how to use Terraform, AWS SSM, and Ansible to provision EC2 instances with configuration management.

Usage
-----

```
export AWS_PROFILE=<PROFILE>
terraform init

terraform plan \
  -var vpc_id="<VPC_ID>" \
  -var subnet_id="<SUBNET_ID>"

terraform apply \
  -var vpc_id="<VPC_ID>" \
  -var subnet_id="<SUBNET_ID>"
```

Clean up:

```
terraform plan -destroy \
  -var vpc_id="<VPC_ID>" \
  -var subnet_id="<SUBNET_ID>"

terraform destroy \
  -var vpc_id="<VPC_ID>" \
  -var subnet_id="<SUBNET_ID>"
```
