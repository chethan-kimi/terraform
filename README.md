         ┌────────────────────────────┐
         │        VPC (10.x.0.0/16)   │
         └────────────────────────────┘
               │               │
         ┌─────▼─────┐   ┌─────▼─────┐
         │ Public     │   │ Private    │
         │ Subnets x2 │   │ Subnets x2 │
         └─────┬─────┘   └─────┬─────┘
               │               │
         ┌─────▼─────┐   ┌─────▼────────────────────────────────────────┐
         │  IGW      │   │ NAT Gateway (EIP)                            │
         └─────┬─────┘   └──────────────────────────────────────────────┘
               │
        ┌──────▼─────┐
        │ LoadBalancer│  <-- nginx container exposed via ECS Fargate
        └──────┬─────┘
               │
         ┌─────▼─────┐
         │ ECS Cluster│
         └────────────┘

         ┌────────────────────┐
         │     S3 Bucket      │
         └────────────────────┘




## ✅ Highlights for ECS Demo

### 🔹 Modules

* `network/`: VPC, Subnets (2 AZs), IGW, NAT, Route Tables, SG, NACL
* `ecs/`: ECS Fargate Cluster, ALB, Listener, Task, IAM Role
* `s3/`: One bucket per env (`env` tagged)

### 🔹 Architecture Design Strengths

* Environment isolation via `*.tfvars`
* NAT ensures private subnet tasks pull Docker images
* Modular structure for easy scalability and maintenance
* `.gitignore` for sensitive and generated files


# Multi-Environment AWS Infrastructure with Terraform Modules

This project provisions complete AWS infrastructure using **modular Terraform** design. 
It supports `dev`, `staging`, and `prod` environments using separate `.tfvars` files, with a shared reusable module structure.


## 🔧 Components Created Per Environment

Each environment (dev/staging/prod) will have the following resources:

### 1. **Networking (VPC)**

* One VPC with CIDR from `.tfvars`
* One Public Subnet
* One Private Subnet
* Internet Gateway (attached to public subnet)
* Route Tables

### 2. **Security**

* Security Group (Ingress on port 80)
* Network ACL with basic allow rules

### 3. **ECS Fargate**

* ECS Cluster
* Task Definition (using Nginx container)
* IAM Role for ECS task execution
* Fargate Service in private subnet
* Application Load Balancer in public subnet

### 4. **S3 Bucket**

* One S3 bucket per environment

## 🚀 Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Plan and Apply

```bash
# For dev
echo "Running dev setup..."
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# For staging
echo "Running staging setup..."
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"

# For prod
echo "Running prod setup..."
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

## 📁 Directory Structure

```
.
├── main.tf
├── variables.tf
├── dev.tfvars
├── staging.tfvars
├── prod.tfvars
└── modules
    ├── network
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ecs
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── s3
        ├── main.tf
        ├── variables.tf
        └── outputs.tf


## 🛡️ Best Practices Followed

* Variables and environments separated using `.tfvars`
* Reusable modules for better maintenance
* Security Groups and NACLs properly scoped
* Clear tagging (`env`-based)
* All resources have proper dependencies using `depends_on`

## 📌 Prerequisites

* Terraform CLI v1.3+
* AWS CLI configured with credentials
* AWS account with IAM permissions to create VPC, ECS, S3, IAM, etc.
