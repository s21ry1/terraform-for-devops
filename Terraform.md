# Terraform Notes: Basic to Advanced with example scripts

## Introduction
Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using a declarative configuration language.

---

## Basic Concepts

- **Provider**: A plugin that allows Terraform to interact with APIs of cloud providers (e.g., AWS, Azure, GCP).
- **Resource**: The basic building block of Terraform, representing infrastructure components (e.g., EC2 instance, S3 bucket).
- **Variable**: Used to make configurations flexible and reusable.
- **Output**: Used to display values after Terraform applies changes.
- **State File**: Tracks the current state of your infrastructure.

---

## Basic Workflow
1. **Write**: Define resources in `.tf` files.
2. **Init**: Run `terraform init` to initialize the working directory.
3. **Plan**: Run `terraform plan` to see what will be created/changed.
4. **Apply**: Run `terraform apply` to make changes.
5. **Destroy**: Run `terraform destroy` to remove resources.

---

## Intermediate Concepts

- **Modules**: Reusable groups of resources. Helps organize and share code.
- **Data Sources**: Fetch data from providers for use in your configuration.
- **Provisioners**: Execute scripts or commands on resources after creation.
- **Remote State**: Store state files remotely (e.g., S3) for team collaboration.
- **Terraform Cloud/Enterprise**: Managed services for collaboration and governance.

---

## Advanced Topics

- **Workspaces**: Manage multiple environments (e.g., dev, prod) from the same configuration.
- **Lifecycle Rules**: Control resource creation, update, and deletion behavior.
- **Custom Providers**: Write your own provider plugins.
- **State Locking**: Prevent concurrent modifications to state files.
- **Dependency Management**: Use `depends_on` to control resource creation order.
- **Sensitive Data Handling**: Mark outputs/variables as sensitive to avoid accidental exposure.
- **Testing**: Use tools like `terratest` for automated testing of Terraform code.

---

## Best Practices
- Use version control (e.g., Git) for your Terraform code.
- Keep state files secure and backed up.
- Use modules for reusable code.
- Document your code and use meaningful resource names.
- Regularly run `terraform plan` to review changes before applying.

---

## Example: Simple EC2 Instance
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

---

## Useful Commands
- `terraform fmt` – Format configuration files
- `terraform validate` – Check configuration syntax
- `terraform taint` – Mark a resource for recreation
- `terraform import` – Import existing infrastructure

---

## Conclusion
Terraform is a powerful tool for automating infrastructure. Mastering its features from basic to advanced will help you manage cloud resources efficiently and reliably.
