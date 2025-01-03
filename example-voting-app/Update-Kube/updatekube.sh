#!/bin/bash
set -xe  # Enable debugging and stop execution on error

git clone https://${GITHUB_TOKEN}@github.com/vipulkalebag/End-To-End-Deployment.git

cd End-To-End-Deployment/example-voting-app || exit 1

# DockerHub credentials
DOCKERHUB_USERNAME="vipul4518"

echo "Current directory: $(pwd)"

# Images and Tags
IMAGE_TAG=${BUILD_NUMBER}  # Default to 'latest' if BUILD_NUMBER is not set
IMAGES=("voteimg" "resultimg" "workerimg")  # Array of image names
DEPLOYMENT_FILES=(
    "./kube-spec/vote-deployment.yaml"
    "./kube-spec/result-deployment.yaml"
    "./kube-spec/worker-deployment.yaml"
)  # Array of corresponding deployment files

# Update and deploy each image
for i in "${!IMAGES[@]}"; do
  IMAGE_NAME="${IMAGES[$i]}"
  DEPLOYMENT_FILE="${DEPLOYMENT_FILES[$i]}"
  DOCKERHUB_IMAGE="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

  if [ -f "$DEPLOYMENT_FILE" ]; then
    # Update the image in the deployment file
    sed -i "s|image:.*|image: ${DOCKERHUB_IMAGE}|g" "$DEPLOYMENT_FILE"
    echo "Updated deployment file: $DEPLOYMENT_FILE"
    cat "$DEPLOYMENT_FILE"
  else
    echo "Error: Deployment file not found for $IMAGE_NAME at $DEPLOYMENT_FILE!"
    exit 1
  fi
done

# Git operations
git config --global user.email "vipulkalebag.1317@gmail.com"
git config --global user.name "vipulkalebag"

git add .
git commit -m "Update Kubernetes manifests for all microservices with DockerHub images"
git push origin main