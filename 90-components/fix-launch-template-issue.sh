#!/bin/bash
# Quick fix script for launch template issues

set -e

echo "=========================================="
echo "Launch Template Issue Fix Script"
echo "=========================================="
echo ""

cd "$(dirname "$0")" || exit

# Step 1: Check if launch templates exist in AWS
echo "Step 1: Checking AWS for launch templates..."
CATALOGUE_EXISTS=$(aws ec2 describe-launch-templates --launch-template-names roboshop-dev-catalogue --region us-east-1 --query 'LaunchTemplates[0].LaunchTemplateId' --output text 2>/dev/null || echo "")
USER_EXISTS=$(aws ec2 describe-launch-templates --launch-template-names roboshop-dev-user --region us-east-1 --query 'LaunchTemplates[0].LaunchTemplateId' --output text 2>/dev/null || echo "")

# Step 2: Check if they're in Terraform state
echo "Step 2: Checking Terraform state..."
CATALOGUE_IN_STATE=$(terraform state list 2>/dev/null | grep 'module.component\["catalogue"\].aws_launch_template.main' || echo "")
USER_IN_STATE=$(terraform state list 2>/dev/null | grep 'module.component\["user"\].aws_launch_template.main' || echo "")

echo ""
echo "Status:"
echo "  Catalogue in AWS: $([ -n "$CATALOGUE_EXISTS" ] && echo "YES (ID: $CATALOGUE_EXISTS)" || echo "NO")"
echo "  Catalogue in State: $([ -n "$CATALOGUE_IN_STATE" ] && echo "YES" || echo "NO")"
echo "  User in AWS: $([ -n "$USER_EXISTS" ] && echo "YES (ID: $USER_EXISTS)" || echo "NO")"
echo "  User in State: $([ -n "$USER_IN_STATE" ] && echo "YES" || echo "NO")"
echo ""

# Step 3: Fix based on situation
if [ -n "$CATALOGUE_EXISTS" ] && [ -z "$CATALOGUE_IN_STATE" ]; then
    echo "Fixing catalogue: Importing from AWS..."
    terraform import 'module.component["catalogue"].aws_launch_template.main' "$CATALOGUE_EXISTS"
elif [ -z "$CATALOGUE_EXISTS" ] && [ -n "$CATALOGUE_IN_STATE" ]; then
    echo "Fixing catalogue: Removing orphaned state entry..."
    terraform state rm 'module.component["catalogue"].aws_launch_template.main'
elif [ -z "$CATALOGUE_EXISTS" ] && [ -z "$CATALOGUE_IN_STATE" ]; then
    echo "Catalogue: Not in AWS or state - will be created by Terraform"
else
    echo "Catalogue: Already in sync"
fi

if [ -n "$USER_EXISTS" ] && [ -z "$USER_IN_STATE" ]; then
    echo "Fixing user: Importing from AWS..."
    terraform import 'module.component["user"].aws_launch_template.main' "$USER_EXISTS"
elif [ -z "$USER_EXISTS" ] && [ -n "$USER_IN_STATE" ]; then
    echo "Fixing user: Removing orphaned state entry..."
    terraform state rm 'module.component["user"].aws_launch_template.main'
elif [ -z "$USER_EXISTS" ] && [ -z "$USER_IN_STATE" ]; then
    echo "User: Not in AWS or state - will be created by Terraform"
else
    echo "User: Already in sync"
fi

echo ""
echo "=========================================="
echo "Fix Complete! Running terraform plan..."
echo "=========================================="
terraform plan

echo ""
echo "If the plan looks good, run: terraform apply"
