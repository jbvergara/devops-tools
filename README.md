# devops-tools

## **I. AWS**

### **aws-cred-profile-with-token.sh**
#### Description:
Script to obtain temporary AWS Credentials with Session Token and apply it to the \
default profile

#### Input Arguments:
1. ACCESS_KEY 
2. SECRET_ACCESS_KEY
3. REGION 
4. ACCESS_DURATION
5. MFA_DEVICE_ARN
6. MFA_CODE

#### Note:
Don't forget to delete aws_session_token in your 'default' profile when switching to a different credential
