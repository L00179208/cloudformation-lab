#!/bin/bash

# Check if the AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo "AWS CLI is not installed. Please install it and configure your credentials."
  exit 1
fi

# Check if the template URL parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <template_file>"
  exit 1
fi

# Extract the template URL from the parameter
template_file="$1"

# Stack name (change as needed)
stack_name="$2"

# Execute CloudFormation stack creation
aws cloudformation create-stack \
  --stack-name "$stack_name" \
  --template-body "file://$template_file" 

# Wait for the stack creation to complete
aws cloudformation wait stack-create-complete --stack-name "$stack_name"

# Check the stack creation status
stack_status=$(aws cloudformation describe-stacks --stack-name "$stack_name" --query "Stacks[0].StackStatus" --output text)

if [ "$stack_status" = "CREATE_COMPLETE" ]; then
  echo "Stack creation completed successfully."
else
  echo "Stack creation failed with status: $stack_status"
fi
