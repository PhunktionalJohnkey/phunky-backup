REGION="eu-west-2"
ECR_URI="423623861502.dkr.ecr.eu-west-2.amazonaws.com"
ECR_REPOSITORY="phunkytech/web-waf-dev-flask"
ECR_REPOSITORY_URI="$ECR_URI/$ECR_REPOSITORY"
TAG="latest"
export IMAGE_ID="$ECR_REPOSITORY_URI:$TAG"