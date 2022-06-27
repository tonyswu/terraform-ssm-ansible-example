data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata_template.sh")
}

resource "aws_instance" "ssm_example" {
  ami                         = data.aws_ami.amazon_linux_2.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ssm_example.name
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids      = [ aws_security_group.ssm_example.id ]
  tags                        = { "Name" = "ssm-example" }

  root_block_device {
    encrypted   = true
    volume_type = var.ec2_volume_type
    volume_size = var.ec2_volume_size
  }

  lifecycle {
    ignore_changes = [ami, user_data_base64, ebs_optimized]
  }
}
