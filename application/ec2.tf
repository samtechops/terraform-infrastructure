
resource "aws_launch_template" "go_app" {
  name          = local.component
  image_id      = data.aws_ami.amazonlinux2_ami.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true

    }
  }

  lifecycle {
    create_before_destroy = true
  }


  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.ec2.id]
  }

  user_data = base64encode(templatefile("templates/userdata.tpl", {
  }))


  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.default_tags,
      {
        "Name" = local.component
      },
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.default_tags,
      {
        "Name" = local.component
      },
    )
  }

}


############## ASG ##################################


#####################################################

resource "aws_autoscaling_group" "go_app" {
  name                      = "${aws_launch_template.go_app.name}-${aws_launch_template.go_app.latest_version}"
  vpc_zone_identifier       = [data.terraform_remote_state.base.outputs.private_subnet_id]
  min_size                  = var.ec2_asg_minimum_size
  max_size                  = var.ec2_asg_maximum_size
  desired_capacity          = var.ec2_asg_desired_capacity
  default_cooldown          = 30
  health_check_grace_period = 25

  launch_template {
    id      = aws_launch_template.go_app.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge(local.default_tags,
      {
        "Name"              = local.component
    })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  depends_on = [aws_launch_template.go_app]
}

