# ☁️️ Automated Cloud Infrastructure & Configuration Management

[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Config_Mgmt-Ansible-EE0000?logo=ansible)](https://www.ansible.com/)
[![AWS](https://img.shields.io/badge/Cloud-AWS_ap--south--1-232F3E?logo=amazon-aws)](https://aws.amazon.com/)
[![Linux](https://img.shields.io/badge/OS-Ubuntu_22.04_LTS-E95420?logo=ubuntu)](https://ubuntu.com/)
[![Security](https://img.shields.io/badge/Security-UFW_%26_SSH_Hardened-green)](https://www.ssh.com/)

An enterprise-grade Infrastructure as Code (IaC) and automated configuration management workflow provisioning isolated cloud networking topologies on AWS and standardizing remote server baselines via Ansible.

---

## 📌 Architecture Overview

```text
               +--------------------------------------+
               |        Engineer Machine / WSL        |
               +-------------------+------------------+
                                   |
                                   | 1. terraform apply
                                   v
+------------------------------------------------------------------+
|                     AWS Cloud (ap-south-1)                       |
|                                                                  |
|   +----------------------------------------------------------+   |
|   | Custom VPC: 10.0.0.0/16                                  |   |
|   |                                                          |   |
|   |   +---------------------+        +--------------------+  |   |
|   |   | Internet Gateway    |        | Custom Route Table |  |   |
|   |   +----------+----------+        +---------+----------+  |   |
|   |              |                             |             |   |
|   |              +--------------+--------------+             |   |
|   |                             |                            |   |
|   |                             v                            |   |
|   |   +--------------------------------------------------+   |   |
|   |   | Public Subnet (10.0.1.0/24)                      |   |   |
|   |   |                                                  |   |   |
|   |   |  +--------------------------------------------+  |   |   |
|   |   |  | Security Group (Port 22 SSH, Port 80 HTTP) |  |   |   |
|   |   |  |                                            |  |   |   |
|   |   |  |    +----------------------------------+    |  |   |   |
|   |   |  |    | Ubuntu 22.04 EC2 (t3.micro)      |    |  |   |   |
|   |   |  |    +-----------------+----------------+    |  |   |   |
|   |   |  +----------------------|---------------------+  |   |   |
|   |   +-------------------------|------------------------+   |   |
|   +-----------------------------|----------------------------+   |
+---------------------------------|--------------------------------+
                                  |
                                  | 2. ansible-playbook (over SSH)
                                  v
+------------------------------------------------------------------+
|             Remote Server Configuration Baseline                 |
|  - Automated Package Cache & Dependency Sync (Nginx, curl, htop) |
|  - Custom Web Application Deployment                             |
|  - systemd Service Automation (Auto-restart on boot)             |
|  - UFW Security Hardening (Default Deny, Scoped Ingress)         |
+------------------------------------------------------------------+
🛠️ Key Technologies & Architectural Decisions
Infrastructure as Code (IaC): Modularized HCL codebase provisioning a dedicated custom VPC, CIDR block allocation (10.0.0.0/16), Public Subnet (10.0.1.0/24), Internet Gateway, route table associations, and custom Security Groups.

Automated Configuration Management: Developed idempotency-tested Ansible playbooks automating OS package patching, Nginx web engine provisioning, and dynamic service management.

Defense-in-Depth Security:

Enforced SSH key-based authentication with RSA 4096-bit keys (disabling password authentication).

Layered network boundary controls with AWS Security Groups and host-level UFW firewalls configured with a default-deny posture.

Service Reliability: Configured systemd lifecycle controls to ensure automatic recovery across server reboot cycles.

🚀 Repository Structure
Plaintext
├── terraform/
│   ├── provider.tf      # AWS provider and version constraints
│   ├── main.tf          # VPC, Subnet, IGW, Route Table, SG, and EC2 specs
│   └── outputs.tf       # Exported VPC IDs, Instance IDs, and Public IPs
├── ansible/
│   ├── ansible.cfg      # Custom connection parameters and SSH paths
│   ├── inventory.ini    # Managed host target definitions
│   └── playbook.yml     # Automated server configuration tasks
├── .gitignore           # Ignores sensitive tfstate and private keys
└── README.md            # Architecture documentation and specs
⚙️ Quickstart & Reproduction
1. Provision Infrastructure via Terraform
Bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
2. Configure Server via Ansible
Bash
cd ../ansible
ansible webservers -m ping
ansible-playbook playbook.yml
3. Verify Health
Bash
curl -I http://<EC2_PUBLIC_IP>
👤 Author
Sameer Khan — DevOps & Cloud Engineer

GitHub: @kkhansameer94
