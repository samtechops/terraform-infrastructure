#!/bin/bash
set -x

: "${TF_S3_STATE_BUCKET:?Variable not set or empty}"
: "${AWS_DEFAULT_REGION:?Variable not set or empty}"



BUCKET_EXISTS=$(aws s3api list-buckets --query "Buckets[?Name=='$TF_S3_STATE_BUCKET'].Name" --output text)
if ((${#BUCKET_EXISTS} == 0)); then
  aws s3api create-bucket --acl private --bucket $TF_S3_STATE_BUCKET --region $AWS_DEFAULT_REGION --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
  aws s3api put-bucket-versioning --bucket $TF_S3_STATE_BUCKET --region $AWS_DEFAULT_REGION --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket $TF_S3_STATE_BUCKET --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
  aws s3api put-public-access-block --bucket $TF_S3_STATE_BUCKET --region $AWS_DEFAULT_REGION --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
fi


