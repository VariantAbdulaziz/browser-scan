#!/bin/bash
set -e
export AWS_REGION="eu-north-1"
NAMESPACE="browserscan"

# Fetch SSM parameters
for param in SECRET_KEY DEBUG DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD; do
  value=$(aws ssm get-parameter --name "/${NAMESPACE}/$param" --with-decryption --query "Parameter.Value" --output text --region ${AWS_REGION} 2>/dev/null)
  if [ -z "$value" ]; then
    echo "SSM parameter /${NAMESPACE}/$param not found!"
    exit 1
  fi
  export $param=$value
  echo "export $param=$value" >> /home/ec2-user/.bash_profile
done
