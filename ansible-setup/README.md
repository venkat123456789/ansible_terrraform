# Ansible server using Terraform

* Creates a vpc
* creates a public subnet
* creates a internet gateway for VPC
* creates a route table and associate it with public subnet
* creates a security group for the subnet (ingress and egress rules)
* create a new key pair ---> generate the key in machine and copy the public key value
* create a ec2 instance
* Using local-exec provisioner copy the script from src to dest
* Using remote-exec provisioner chnage per and exec the script on new machine




## Steps to execute

Git clone `project_url`
- Update with all the varibles


$ terraform init

$ terraform plan

$ terraform apply

