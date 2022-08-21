#!/bin/bash

#Obtain User Input
read -p "Enter Access Key: " ACCESS_KEY
ACCESS_KEY=${ACCESS_KEY}
read -p "Enter Secret Access Key: " SECRET_ACCESS_KEY
SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
read -p "Enter Default Region [ap-southeast-1]: " REGION
REGION=${REGION:-ap-southeast-1}
read -p "Enter access duration in seconds [43200]: " ACCESS_DURATION
ACCESS_DURATION=${ACCESS_DURATION:-43200}
read -p "Enter MFA Device ARN: " MFA_DEVICE_ARN
MFA_DEVICE_ARN=${MFA_DEVICE_ARN}
read -p "Enter MFA code: " MFA_CODE
MFA_CODE=${MFA_CODE}

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
set_aws_credentials "$ACCESS_KEY" "$SECRET_ACCESS_KEY" "$REGION"

echo "Requesting STS token..."
read TMP_ACCESS_KEY TMP_SECRET_ACCESS_KEY SESSION_TOKEN <<< \
"$( aws sts get-session-token \
  --duration $ACCESS_DURATION \
  --profile default \
  --serial-number $MFA_DEVICE_ARN \
  --token-code $MFA_CODE \
  --output text  | awk '{ print $2, $4, $5 }')"

echo "Applying Temporary Credentials to 'default' profile..."
set_aws_credentials "$TMP_ACCESS_KEY" "$TMP_SECRET_ACCESS_KEY" "$REGION" "$SESSION_TOKEN"

echo "Done"
echo "NOTE: Don't forget to delete aws_session_token in your 'default' profile when switching to a different credential"




