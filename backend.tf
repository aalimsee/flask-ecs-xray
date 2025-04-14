

terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "aaron/flask-ecs-xray.tfstate"
    region = "us-east-1"
  }
}
