# AWS Infrastructure with Terraform

🚀 AWS Infrastructure Automation Using Terraform

This project provisions a complete AWS infrastructure using Terraform, including VPC networking, ECS cluster (EC2 launch type), Classic Load Balancer (CLB/ELB), RDS PostgreSQL, NAT Gateway, IAM roles, and security groups.

## 📁 File Structure

```
├── main.tf        # Main configuration and provider setup
├── vpc.tf         # Network setup (VPC, subnets, gateways)
├── security.tf    # Security rules (who can talk to whom)
├── alb.tf         # Load balancer (traffic distributor)
├── ecs.tf         # Application servers (where your app runs)
├── rds.tf         # Database (where your data lives)
└── README.md      # This file
```

## 🧩 Components Explained

### 1. **VPC (Virtual Private Cloud)**
- **What it is**: Your own private section of AWS cloud
- **Why we need it**: Like having your own private neighborhood in a big city
- **IP Range**: 10.0.0.0/16 (gives us 65,536 IP addresses)

### 2. **Subnets**
- **Public Subnets**: Connected to internet (like front yard)
- **Private Subnets**: Hidden from internet (like backyard)
- **Availability Zones**: Different physical locations for backup

### 3. **Internet Gateway (IGW)**
- **What it is**: The main entrance to your VPC from the internet
- **Why we need it**: So people can reach your website

### 4. **NAT Gateway**
- **What it is**: Allows private servers to reach internet safely
- **Why we need it**: So your app servers can download updates but stay hidden

### 5. **Application Load Balancer (ALB)**
- **What it is**: Traffic director that distributes visitors
- **Why we need it**: Prevents any single server from getting overwhelmed
- **Location**: Public subnets (faces the internet)

### 6. **ECS (Elastic Container Service)**
- **What it is**: Manages your application servers
- **Why we need it**: Automatically scales up/down based on traffic
- **Location**: Private subnets (hidden from direct internet access)

### 7. **Auto Scaling Group**
- **What it is**: Automatically adds/removes servers based on demand
- **Range**: 1-3 servers (minimum 1, maximum 3, starts with 2)

### 8. **RDS (Relational Database Service)**
- **What it is**: Managed PostgreSQL database
- **Why we need it**: Stores your application data safely
- **Features**: Automatic backups, runs in multiple zones for safety

### 9. **Security Groups**
- **What they are**: Digital firewalls with specific rules
- **ALB Security Group**: Allows internet traffic on port 80
- **ECS Security Group**: Only allows traffic from ALB
- **RDS Security Group**: Only allows database connections from ECS

## 🚀 How to Deploy

### Prerequisites
1. **AWS Account**: You need an active AWS account
2. **AWS CLI**: Install and configure with your credentials
3. **Terraform**: Install Terraform on your computer

### Steps
1. **Clone this repository**
   ```bash
   git clone <your-repo-url>
   cd terraform-aws-infrastructure
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

5. **Clean up (when done)**
   ```bash
   terraform destroy
   ```

## 🔒 Security Features

- **Private Subnets**: App servers and database are hidden from internet
- **Security Groups**: Act like firewalls with specific rules
- **NAT Gateway**: Secure outbound internet access for private resources
- **Multi-AZ**: Resources spread across multiple data centers
- **Encrypted Database**: RDS storage is encrypted
- **Least Privilege**: Each component only has minimum required permissions

## 💰 Cost Considerations (ap-south-1 Mumbai)

**Estimated Hourly Cost**: ~₹2.5-3.5 per hour (~₹1,800-2,500/month)

**Free Tier Resources (₹0/hour):**
- **EC2 t2.micro**: Free for 750 hours/month
- **RDS db.t2.micro**: Free for 750 hours/month  
- **Classic Load Balancer**: Free for 750 hours/month
- **VPC, Subnets, Security Groups**: Always free

**Paid Resources:**
- **NAT Gateway**: ₹2.5/hour (~₹1,800/month) - biggest cost
- **Data Transfer**: ₹0.75/GB outbound
- **EBS Storage**: ₹0.75/GB/month for GP2

**Note**: Costs apply only after free tier limits are exceeded

## 🔧 Customization

To modify this setup:
1. **Change instance sizes**: Edit `instance_type` in `ecs.tf`
2. **Adjust database size**: Edit `instance_class` in `rds.tf`
3. **Scale limits**: Modify `min_size`/`max_size` in Auto Scaling Group
4. **Region**: Change `region` in `main.tf`

## 📊 Traffic Flow

```
User Request → Internet → ALB → ECS Servers → RDS Database
     ↑                    ↓         ↓            ↓
   Response ← Internet ← ALB ← ECS Servers ← RDS Database
```

## 🆘 Troubleshooting

**Common Issues:**
1. **Permission Denied**: Check AWS credentials
2. **Resource Limits**: Verify AWS account limits
3. **Region Issues**: Ensure all resources in same region
4. **Terraform State**: Don't delete `.tfstate` files

