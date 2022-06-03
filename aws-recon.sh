#!/bin/bash

# Sample AWS exploit
# 1. Conducts reconnaissance by listing users, EC2 instances, KMS Keys, Security Groups 
# Uses aws cli, which supports environment variables for PROFILE, REGION, ACCESS KEY ID, SECRET KEY etc...

set -e

grn=$'\e[1;32m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

function getRegions {
  aws ec2 describe-regions --output json | jq -r '.[] | .[] | .RegionName'
}

function getInstances {
  aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running,stopped --region $r --output json --no-paginate | jq 'flatten | length'
}

function getKMSKeys {
  aws kms list-keys --region $r --output json | jq
}

function getEC2SecurityGroups {
  aws ec2 describe-security-groups --region $r --output json | jq
}

function getDBSecurityGroups {
  aws rds describe-security-groups --region $r --query 'DBSecurityGroups[*].EC2SecurityGroups[*].EC2SecurityGroupId' --output json | jq
}

function getSecrets {
  aws secretsmanager list-secrets --region $r --output json | jq
}

function getUsers {
  aws iam list-users --output json | jq
}

function awsRecon {
    echo "${grn}Conducting AWS reconnaissance...${end}"
    echo "  ${grn}Querying AWS for list of users...${end}"
    
    Users=$(getUsers $PROFILE)
    #echo "Users: $Users"

    echo "  ${grn}Querying each AWS region for EC2 Instances, KMS Keys, EC2 Security Groups and Secrets...${end}"
    #echo ""

    for r in $(getRegions); do
        echo "    Querying region: ${cyn}$r${end}"
        Instances=$(getInstances $r $PROFILE)
        #echo "Instances: $Instances"
        KMSKeys=$(getKMSKeys $r $PROFILE)
        #echo "KMSKeys: $KMSKeys"
        EC2SecurityGroups==$(getEC2SecurityGroups $r $PROFILE)
        #echo "SecurityGroups: $SecurityGroups"
        Secrets=$(getSecrets $r $PROFILE)
        #echo "Secrets: $Secrets"
    done
    echo "${grn}AWS reconnaissance complete${end}"
}

# Conduct example AWS Reconnaisance
awsRecon

echo ""
echo "${cyn}Script complete. Check your Lacework console for activity in about an hour.${end}"