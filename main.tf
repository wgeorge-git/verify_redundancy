provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }

  owners = ["099720109477"]
}

// VIOLATION: Policy ID: lacework-iac-aws-security-9
// VIOLATION: Title: Missing description for security group/security group rule
// VIOLATION: Severity: Low
// VIOLATION: Compliance: None
resource "aws_security_group" "my_security_group" {
  name_prefix = "example-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// VIOLATION: Policy ID: lacework-iac-aws-compute-6
// VIOLATION: Title: Ensure EC2 Instances Are EBS-Optimized for Enhanced Performance
// VIOLATION: Severity: Low
// VIOLATION: Compliance: None

// VIOLATION: Policy ID: lacework-iac-aws-general-1
// VIOLATION: Title: Ensure Instance Metadata Service Version 1 is not enabled
// VIOLATION: Severity: Low
// VIOLATION: Compliance: None

// VIOLATION: Policy ID: lacework-iac-aws-monitoring-1
// VIOLATION: Title: Ensure that detailed monitoring is enabled for EC2 instances
// VIOLATION: Severity: Low
// VIOLATION: Compliance: None

// VIOLATION: Policy ID: lacework-iac-aws-encryption-1
// VIOLATION: Title: Launch configuration with unencrypted EBS block device
// VIOLATION: Severity: High
// VIOLATION: Compliance: None
resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyInstance"
  }
}

// VIOLATION: Policy ID: lacework-iac-azure-secrets-1
// VIOLATION: Title: Azure Key Vault secrets should have an expiration date configured
// VIOLATION: Severity: Medium
// VIOLATION: Compliance: None

// VIOLATION: Policy ID: lacework-iac-azure-security-28
// VIOLATION: Title: Ensure Key Vault Secrets Have Content Type Defined
// VIOLATION: Severity: Low
// VIOLATION: Compliance: None
resource "azurerm_key_vault_secret" "secret_example_0" {
  name         = "secret_with_expiration_0"
  key_vault_id = azurerm_key_vault.example_key_vault.id
  value        = "secret_password_0"
}
