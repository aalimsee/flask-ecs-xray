

# Secrets Manager Secret

resource "aws_secretsmanager_secret" "db_password" {
  name = "aaron/db_password"

  tags = {
    Name = "aaron-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = "MySecretPassword123" # not secure. for testing only!
}

