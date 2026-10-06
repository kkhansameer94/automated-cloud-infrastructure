# 🚀 Automated Cloud Infrastructure with Terraform & Ansible

[![Terraform](https://img.shields.io/badge/Terraform-1.x-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Linux](https://img.shields.io/badge/Linux-System%20Administration-FCC624?logo=linux&logoColor=black)](https://www.linux.org/)

> **Infrastructure as Code and configuration management project that automates AWS infrastructure provisioning and secure Ubuntu server configuration using Terraform and Ansible.**

---

## 📌 Project Overview

This project demonstrates an end-to-end **Infrastructure as Code (IaC)** workflow for provisioning and configuring a web server on AWS.

Instead of manually creating AWS resources and configuring the server through SSH commands, the entire workflow is automated using:

- **Terraform** for AWS infrastructure provisioning
- **Ansible** for server configuration management
- **AWS EC2** for cloud compute
- **Ubuntu 22.04 LTS** as the operating system
- **Nginx** as the web server
- **UFW** for host-level firewall protection
- **systemd** for service lifecycle management

The architecture is designed to be **repeatable, consistent, and idempotent**, reducing manual configuration and improving deployment reliability.

---

## 🏗️ Architecture

```text
                        +---------------------------+
                        |     Engineer Machine      |
                        |        / WSL / Linux      |
                        +-------------+-------------+
                                      |
                                      | terraform apply
                                      v
              +------------------------------------------------+
              |                  AWS Cloud                     |
              |                  ap-south-1                    |
              |                                                |
              |  +------------------------------------------+  |
              |  |              Custom VPC                  |  |
              |  |              10.0.0.0/16                  |  |
              |  |                                          |  |
              |  |   +-------------------+                  |  |
              |  |   | Internet Gateway  |                  |  |
              |  |   +---------+---------+                  |  |
              |  |             |                            |  |
              |  |   +---------v-------------------------+  |  |
              |  |   |        Public Route Table        |  |  |
              |  |   +---------+------------------------+  |  |
              |  |             |                            |  |
              |  |   +---------v------------------------+   |  |
              |  |   |      Public Subnet               |   |  |
              |  |   |      10.0.1.0/24                 |   |  |
              |  |   |                                  |   |  |
              |  |   |  +------------------------------+ |   |  |
              |  |   |  |       Security Group        | |   |  |
              |  |   |  |       SSH / HTTP            | |   |  |
              |  |   |  |                              | |   |  |
              |  |   |  |   +----------------------+   | |   |  |
              |  |   |  |   | Ubuntu 22.04 EC2    |   | |   |  |
              |  |   |  |   |      t3.micro        |   | |   |  |
              |  |   |  |   +----------------------+   | |   |  |
              |  |   |  +------------------------------+ |   |  |
              |  |   +----------------------------------+   |  |
              |  +------------------------------------------+  |
              +----------------------+-------------------------+
                                     |
                                     | ansible-playbook
                                     | over SSH
                                     v
              +------------------------------------------------+
              |          Server Configuration Layer             |
              |                                                |
              |  • Package updates and dependencies             |
              |  • Nginx installation and configuration         |
              |  • Application / health interface deployment   |
              |  • systemd service management                  |
              |  • Automatic service recovery                   |
              |  • UFW host-level firewall                     |
              |  • Default-deny inbound policy                  |
              +------------------------------------------------+
```

---

## 🔄 Automation Workflow

```text
Developer / Engineer
        |
        v
Terraform
        |
        +----> VPC
        +----> Public Subnet
        +----> Internet Gateway
        +----> Route Table
        +----> Security Group
        +----> EC2 Instance
        |
        v
AWS Infrastructure Ready
        |
        v
Ansible over SSH
        |
        +----> Update OS packages
        +----> Install required packages
        +----> Configure Nginx
        +----> Deploy application
        +----> Configure systemd
        +----> Configure UFW
        |
        v
Hardened & Configured Web Server
        |
        v
HTTP Health Verification
```

---

## 🛠️ Key Technologies

| Technology | Purpose |
|---|---|
| **Terraform** | AWS infrastructure provisioning |
| **AWS VPC** | Isolated cloud network |
| **AWS EC2** | Compute instance |
| **AWS Security Groups** | Network-level access control |
| **Ansible** | Configuration management |
| **Ubuntu 22.04 LTS** | Server operating system |
| **Nginx** | Web server |
| **systemd** | Service lifecycle management |
| **UFW** | Host-level firewall |
| **SSH** | Secure remote administration |
| **WSL / Linux** | Infrastructure automation environment |

---

## 🏗️ Infrastructure as Code with Terraform

The Terraform configuration provisions a complete AWS networking and compute foundation.

### Resources Provisioned

- Custom VPC — `10.0.0.0/16`
- Public Subnet — `10.0.1.0/24`
- Internet Gateway
- Custom Route Table
- Route Table Association
- Security Group
- Ubuntu 22.04 LTS EC2 instance
- SSH key-based authentication

### AWS Region

```text
ap-south-1
Mumbai, India
```

Terraform allows the infrastructure to be recreated consistently without manually configuring resources through the AWS Console.

---

## ⚙️ Configuration Management with Ansible

After Terraform provisions the EC2 instance, Ansible connects to the server over SSH and applies the desired configuration state.

### Automated Tasks

```text
1. Update package cache
2. Upgrade system packages
3. Install required dependencies
4. Install Nginx
5. Install curl and htop
6. Deploy web/health interface
7. Configure systemd service
8. Enable service at boot
9. Configure UFW firewall
10. Apply required firewall rules
```

Ansible playbooks are designed to be **idempotent**, meaning repeated executions should converge the server toward the desired state rather than unnecessarily recreating configuration.

---

## 🔐 Security & Hardening

Security was considered at multiple layers.

### 1. SSH Key-Based Authentication

The EC2 instance uses SSH key-based authentication instead of password-based access.

```text
RSA 4096-bit SSH key
```

Private keys are excluded from version control through `.gitignore`.

### 2. AWS Security Group

Network-level access is restricted to only the required services.

```text
SSH  → Port 22
HTTP → Port 80
```

> In a production environment, SSH access should ideally be restricted to trusted IP ranges rather than exposed broadly.

### 3. UFW Host Firewall

The server also uses UFW as an additional host-level security layer.

```text
Default incoming policy → DENY
Required services       → ALLOW
```

This creates a layered security model:

```text
Internet
   |
   v
AWS Security Group
   |
   v
EC2 Instance
   |
   v
UFW Firewall
   |
   v
Application / Nginx
```

---

## 🔄 Service Reliability with systemd

The project uses **systemd** to manage the application/service lifecycle.

The service is configured to:

- Start automatically during system boot
- Run as a managed background service
- Restart automatically when configured conditions require recovery
- Maintain service availability after server reboots

This removes the need to manually start the service after every reboot.

---

## 📁 Repository Structure

```text
automated-cloud-infrastructure/
│
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   └── outputs.tf
│
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── playbook.yml
│
├── .gitignore
└── README.md
```

### Terraform

| File | Purpose |
|---|---|
| `provider.tf` | AWS provider and Terraform configuration |
| `main.tf` | VPC, subnet, routing, security group and EC2 resources |
| `outputs.tf` | Outputs such as instance ID and public IP |

### Ansible

| File | Purpose |
|---|---|
| `ansible.cfg` | Ansible connection/configuration settings |
| `inventory.ini` | Managed host definitions |
| `playbook.yml` | Automated server configuration tasks |

---

# 🚀 Quick Start

## Prerequisites

Before running the project, make sure the following are installed and configured:

- AWS account
- AWS CLI
- Terraform
- Ansible
- SSH client
- AWS IAM credentials with appropriate permissions
- Existing SSH key pair or project-generated key
- Linux / WSL environment

Verify installations:

```bash
terraform version
ansible --version
aws --version
ssh -V
```

---

## 1️⃣ Configure AWS Credentials

Configure the AWS CLI:

```bash
aws configure
```

Verify access:

```bash
aws sts get-caller-identity
```

---

## 2️⃣ Provision AWS Infrastructure

Navigate to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Review the infrastructure plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

After successful deployment, Terraform outputs can be used to identify the EC2 instance and public IP.

---

## 3️⃣ Configure the Server with Ansible

Navigate to the Ansible directory:

```bash
cd ../ansible
```

Update `inventory.ini` with the EC2 public IP and correct SSH configuration.

Test connectivity:

```bash
ansible webservers -m ping
```

Run the configuration playbook:

```bash
ansible-playbook playbook.yml
```

---

## 4️⃣ Verify Deployment

Check the web server:

```bash
curl -I http://<EC2_PUBLIC_IP>
```

You can also open the following in a browser:

```text
http://<EC2_PUBLIC_IP>
```

Verify Nginx:

```bash
systemctl status nginx
```

Verify firewall:

```bash
sudo ufw status
```

---

## 🧹 Destroy Infrastructure

When the project is no longer required, destroy the AWS resources to avoid unnecessary cloud costs:

```bash
cd terraform
terraform destroy
```

Review the destruction plan and confirm when prompted.

---

## 🎯 Key Engineering Outcomes

This project demonstrates practical experience with:

- Infrastructure as Code
- AWS cloud provisioning
- Terraform resource management
- VPC networking
- EC2 provisioning
- Security Group configuration
- SSH key-based authentication
- Ansible configuration management
- Idempotent automation
- Linux system administration
- Nginx deployment
- systemd service management
- UFW firewall configuration
- Infrastructure reproducibility
- Automated server configuration

---

## 💡 Key Takeaway

The goal of this project was to move from **manual cloud administration to repeatable infrastructure automation**.

```text
Manual Approach
AWS Console → Manual EC2 Setup → SSH → Manual Configuration
                              ↓
                         Configuration Drift


Automated Approach
Terraform → AWS Infrastructure → Ansible → Server Configuration
                                      ↓
                              Repeatable State
```

The combination of **Terraform for provisioning** and **Ansible for configuration management** creates a clean separation between infrastructure creation and server configuration.

---

## 🔮 Future Improvements

Potential improvements for the next iteration include:

- Remote Terraform state using Amazon S3
- Terraform state locking
- Private subnets and NAT Gateway
- Application Load Balancer
- HTTPS with ACM
- CloudWatch monitoring and logging
- GitHub Actions CI/CD
- Terraform validation and security scanning
- Ansible linting
- Secrets management using AWS Secrets Manager
- Automated infrastructure testing

---

## 👤 Author

**Sameer Khan**  
DevOps & Cloud Engineer

🔗 GitHub: [@kkhansameer94](https://github.com/kkhansameer94)

---

## ⭐ If You Find This Project Useful

If this project helped you understand Terraform, Ansible, AWS infrastructure automation, or Linux configuration management, consider giving the repository a ⭐.
