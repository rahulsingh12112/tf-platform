# Latest Amazon Linux 2023 AMI from the AWS public parameter
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# No inbound rules. Login through SSM Session Manager.
resource "aws_security_group" "ec2" {
  name        = "tf-lab-ec2"
  description = "No inbound. Access via SSM Session Manager."
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "HTTPS out for SSM and package updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Role so the instance can register with SSM
resource "aws_iam_role" "ec2" {
  name = "tf-lab-ec2-ssm"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "tf-lab-ec2-ssm"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "lab" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true # default VPC has no NAT; needed to reach SSM

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_gb
    encrypted   = true
  }

  user_data = <<-SCRIPT
    #!/bin/bash
    dnf -y update
    echo "hello from terraform" > /tmp/hello.txt
  SCRIPT

  tags = {
    Name = "tf-lab-ec2"
  }
}
