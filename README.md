# flask-ecs-xray

# Create a private Amazon ECR repository
```
aws ecr create-repository \
  --repository-name aaron-flask-xray-repo \
  --image-scanning-configuration scanOnPush=true \
  --region us-east-1
```

