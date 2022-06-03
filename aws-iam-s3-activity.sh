#!/bin/sh
# Sample AWS exploit
# 1. Creates a new user with power user privileges, then creates an S3 bucket and puts a file into it.
# 2. The script then cleans up after itself, deleting the bucket and the user.
# Accepts a first optional argument for the username that gets created, otherwise defaults to 'exfiltest'
# Uses aws cli, which supports environment variables for PROFILE, REGION, ACCESS KEY ID, SECRET KEY etc...
# eg. sh ./aws_lateral_movement baduser

set -e

grn=$'\e[1;32m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

USERNAME=${1:-baduser}

# Create a new IAM user
echo "${grn}Creating a new IAM user called ${mag}$USERNAME${end}..."
echo ""
aws iam create-user --user-name $USERNAME | jq
creds=$(aws iam create-access-key --user-name $USERNAME)
echo ""
echo "${grn}Granting PowerUser access to ${mag}$USERNAME${end}..."
aws iam attach-user-policy --user-name $USERNAME --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

if [[ ! -z "$AWS_ACCESS_KEY_ID" ]]; then
  oldaccesskey=$AWS_ACCESS_KEY_ID
  oldsecretaccesskey=$AWS_SECRET_ACCESS_KEY
fi

AWS_ACCESS_KEY_ID=$(echo "${creds}" | jq -r .AccessKey.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo "${creds}" | jq -r .AccessKey.SecretAccessKey)

# Here we start using the new account profile and creds
echo ""
echo "${grn}Creating a new S3 bucket...${end}"
sleep 10
BUCKETNAME="exploit$RANDOM"
aws s3api create-bucket --bucket $BUCKETNAME --region $AWSREGION --create-bucket-configuration LocationConstraint=$AWSREGION | jq

echo ""
echo "${grn}Uploading file to the bucket...${end}"
curl -H "Accept: application/json" https://icanhazdadjoke.com/ > /tmp/badfile.json
aws s3api put-object --bucket $BUCKETNAME --key badfile.json --body /tmp/badfile.json | jq

echo ""
echo "${grn}Data uploaded. Preparing to clean up...${end}"
sleep 10

echo "${grn}Deleting file and S3 bucket...${end}"
aws s3api delete-object --bucket $BUCKETNAME --key badfile.json 
aws s3api delete-bucket --bucket $BUCKETNAME 

# Exit back out to our regular context
if [[ ! -z "$oldaccesskey" ]]; then
  AWS_ACCESS_KEY_ID=$oldaccesskey
  AWS_SECRET_ACCESS_KEY=$oldsecretaccesskey
else
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
fi
echo "${grn}Deleting access key and IAM user ${mag}$USERNAME${end}..."
aws iam detach-user-policy --user-name $USERNAME --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
aws iam delete-access-key --access-key-id $KEY --user-name $USERNAME
aws iam delete-user --user-name $USERNAME

echo ""
echo "${cyn}Script complete. Check your Lacework console for activity in about an hour.${end}"