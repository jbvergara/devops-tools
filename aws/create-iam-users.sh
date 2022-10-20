#!/bin/bash

#Obtain User Input
read -p "Enter Access Key: " ACCESS_KEY
ACCESS_KEY=${ACCESS_KEY}
read -p "Enter Secret Access Key: " SECRET_ACCESS_KEY
SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
read -p "Enter Session Token: " SESSION_TOKEN
SESSION_TOKEN=${SESSION_TOKEN}
read -p "Enter Default Region [us-east-1]: " REGION
REGION=${REGION:-us-east-1}
read -p "Number of Users to be Created [4]: " NUMBER_USERS
NUMBER_USERS=${NUMBER_USERS:-4}
read -p "Enter ARN of the policy to be applied [arn:aws:iam::aws:policy/AdministratorAccess]: " POLICY_ARN
POLICY_ARN=${POLICY_ARN:-arn:aws:iam::aws:policy/AdministratorAccess}


set_aws_credentials () {
  aws configure set aws_access_key_id "$1" --profile default
  aws configure set aws_secret_access_key "$2" --profile default
  aws configure set region "$3" --profile default
  if [ -z "$4" ]
  then
    echo "Credential is not using token"
  else
    aws configure set aws_session_token "$4" --profile default
  fi
}

#Set AWS Credentials
set_aws_credentials "$ACCESS_KEY" "$SECRET_ACCESS_KEY" "$REGION" "$SESSION_TOKEN"

# shellcheck disable=SC2006
for i in `seq 1 "$NUMBER_USERS"`
do
    aws iam create-user --user-name "user-$i" --permissions-boundary "$POLICY_ARN"
    aws iam create-login-profile --user-name "user-$i" --password "rAnDomPass-$i" --password-reset-required
    echo "https://$(aws sts get-caller-identity | jq -r '.Account').signin.aws.amazon.com/console"
    echo "Password: rAnDomPass-$i"
    aws iam create-access-key --user-name "user-$i"
done
