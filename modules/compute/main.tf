resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-${terraform.workspace}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(<<-EOF
#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>Hello from ${terraform.workspace} Environment (Ubuntu)</h1>" > /var/www/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg-${terraform.workspace}"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 2
  vpc_zone_identifier = var.private_subnet_ids

  # Attach ASG to Target Group (NO variable needed)
  target_group_arns = [var.target_group_arn]


  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 120
}
