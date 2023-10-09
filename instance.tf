data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

data "aws_partition" "default" {
}

data "aws_subnet" "default" {
  id = var.subnet
}

data "aws_ami" "default" {
  count       = var.ami == "" ? 1 : 0
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "info" {
  filter {
    name   = "image-id"
    values = [var.ami != "" ? var.ami : join("", data.aws_ami.default.*.image_id)]
  }

  owners = [var.ami != "" ? var.ami_owner : join("", data.aws_ami.default.*.owner_id)]
}


resource "aws_instance" "default" {
  ami                                  = var.ami != "" ? var.ami : join("", data.aws_ami.default.*.image_id)
  availability_zone                    = data.aws_subnet.default.availability_zone
  instance_type                        = var.instance_type
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  # user_data_base64                     = base64encode(var.user_data_tpl)
  user_data                     = var.user_data_tpl
  iam_instance_profile                 = var.instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  associate_public_ip_address          = var.associate_public_ip_address
  subnet_id                            = var.subnet
  monitoring                           = var.monitoring
  source_dest_check                    = var.source_dest_check

  vpc_security_group_ids = var.security_groups

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  root_block_device {
    volume_type           = var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type
    volume_size           = var.root_volume_size
    iops                  = (var.root_volume_type == "io1" || var.root_volume_type == "io2" || var.root_volume_type == "gp3") ? var.root_iops : "0"
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
    throughput = var.root_volume_type == "gp3" ? var.root_throughput : null
    kms_key_id = var.kms_key_id
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled ? "enabled" : "disabled"
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required ? "required" : "optional"
  }

  tags = var.global_tags

  volume_tags = var.global_tags

}