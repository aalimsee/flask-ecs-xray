

resource "aws_security_group" "flask_service_sg" {
  name        = "aaron-flask-service-sg"
  description = "Allow inbound HTTP traffic on port 8080 for Flask ECS Service"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aaron-flask-service-sg"
  }
}
