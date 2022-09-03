#!/bin/bash
set -x

: "${AWS_DEFAULT_REGION:?Variable not set or empty}"

# Create the DynamoDB table for State Locking
if aws dynamodb describe-table --table-name terraform-state-lock --region $AWS_DEFAULT_REGION ; then
  echo "Table already exists"
else
  aws dynamodb create-table --table-name "terraform-state-lock" --attribute-definitions AttributeName=LockID,AttributeType=S --billing-mode "PAY_PER_REQUEST" --key-schema '[{"AttributeName":"LockID","KeyType":"HASH"}]' --sse-specification '{"Enabled":false}' --region $AWS_DEFAULT_REGION
fi
