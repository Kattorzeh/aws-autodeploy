provider "aws" {
  region = var.aws_region 
}

resource "aws_instance" "example" {
  count         = var.ec2_instances
  ami           = var.ec2_instances > 1 ? var.ec2_ami[count.index] : var.ec2_ami[0]
  instance_type = var.ec2_instances > 1 ? var.ec2_instance_type[count.index] : var.ec2_instance_type[0]
  tags = {
    Name = var.ec2_instances > 1 ? var.ec2_name[count.index] : var.ec2_name[0]
    OS   = var.ec2_instances > 1 ? var.ec2_ami_os[count.index] : var.ec2_ami_os[0]
    Tags = var.ec2_tags
  }
}