#Docker build
docker build . -t ab-capstone
docker run -p 8080:8081 -d ab-capstone
docker ps -a

#Push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 417139048224.dkr.ecr.us-east-1.amazonaws.com
docker build -t ab-capstone .
docker tag ab-capstone:latest 417139048224.dkr.ecr.us-east-1.amazonaws.com/ab-capstone:latest
docker push 417139048224.dkr.ecr.us-east-1.amazonaws.com/ab-capstone:latest