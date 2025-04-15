# flask-ecs-xray

# Create a private Amazon ECR repository (if missing)
```
aws ecr create-repository \
  --repository-name aaron-flask-xray-repo \
  --image-scanning-configuration scanOnPush=true \
  --region us-east-1
```

# Create dev environment
```
gh api --method PUT -H "Accept: application/vnd.github+json" /repos/aalimsee/flask-ecs-xray/environments/dev
```

# Create secret variables in dev
```
gh secret set AWS_REGION -b"us-east-1" -r aalimsee/flask-ecs-xray --env dev
gh secret set AWS_ACCOUNT_ID -b"255945442255" -r aalimsee/flask-ecs-xray --env dev
gh secret set ECR_REPOSITORY -b"aaron-flask-xray-repo" -r aalimsee/flask-ecs-xray --env dev
```