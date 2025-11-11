# security group for alb
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-${terraform.workspace}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

# app security group 
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-${terraform.workspace}-app-sg"
  description = "Security group for Application servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}
# db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-${terraform.workspace}-db-sg"
  description = "Allow DB traffic from App"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow DB traffic from app instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}