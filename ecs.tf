

resource "aws_ecs_cluster" "flask_xray_cluster" {
  name = "aaron-flask-xray-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "aaron-flask-xray-cluster"
    Environment = "dev"
  }
}

resource "aws_ecs_cluster_capacity_providers" "flask_xray_capacity_providers" {
  cluster_name = aws_ecs_cluster.flask_xray_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

resource "aws_ecs_task_definition" "flask_xray_taskdef" {
  family                   = "aaron-flask-xray-taskdef"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "flask-app"
      image     = "<your_image_uri>"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "SERVICE_NAME"
          value = "aaron-flask-xray-service"
        }
      ]
      secrets = [
        {
          name      = "MY_APP_CONFIG"
          valueFrom = "arn:aws:ssm:us-east-1:255945442255:parameter/aaron/config"
        },
        {
          name      = "MY_DB_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:us-east-1:255945442255:secret:aaron/db_password-jnecfFs"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/aaron-flask-xray-taskdef"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "flask-app"
        }
      }
    },
    {
      name      = "xray-sidecar"
      image     = "amazon/aws-xray-daemon"
      essential = false
      portMappings = [
        {
          containerPort = 2000
          protocol      = "udp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/aaron-flask-xray-taskdef"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "xray-sidecar"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "flask_service" {
  name            = "aalimsee-flask-service"
  cluster         = aws_ecs_cluster.flask_xray_cluster.id
  task_definition = aws_ecs_task_definition.flask_xray_taskdef.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]  # Replace with your actual subnet IDs
    security_groups  = ["sg-xxxxxxxx"]  # Replace with your ECS Service Security Group ID
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent
