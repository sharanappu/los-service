#!/bin/bash
set -e
IMAGE="$1"
CONTAINER_NAME="los-service"
AWS_REGION="ap-south-1"
if [ -z "$IMAGE" ]; then echo "Usage: $0 <image>"; exit 1; fi
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${IMAGE%%/*}
docker pull "$IMAGE"
if docker ps -q -f name=${CONTAINER_NAME} >/dev/null; then docker stop ${CONTAINER_NAME} || true; docker rm ${CONTAINER_NAME} || true; fi
docker run -d --name ${CONTAINER_NAME} --restart unless-stopped -p 8080:8080 -e SPRING_PROFILES_ACTIVE=prod -e DB_URL="${DB_URL:-jdbc:postgresql://<aurora-endpoint>:5432/appdb}" ${IMAGE}
echo "Deployment finished."
