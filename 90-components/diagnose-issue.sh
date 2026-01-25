#!/bin/bash
# Diagnostic script to identify the exact issue

echo "=========================================="
echo "Launch Template Issue Diagnostic Script"
echo "=========================================="
echo ""

# Check AWS for launch templates
echo "1. Checking AWS for launch templates..."
echo "----------------------------------------"
aws ec2 describe-launch-templates --region us-east-1 --query 'LaunchTemplates[?contains(LaunchTemplateName, `roboshop-dev`)].{Name:LaunchTemplateName,ID:LaunchTemplateId}' --output table 2>/dev/null

if [ $? -ne 0 ]; then
    echo "ERROR: Could not query AWS. Check your AWS credentials and region."
    exit 1
fi

echo ""
echo "2. Checking Terraform state..."
echo "----------------------------------------"
cd "$(dirname "$0")" || exit
terraform state list 2>/dev/null | grep -E "(launch_template|component)" || echo "No launch templates found in state"

echo ""
echo "3. Checking for specific launch templates in state..."
echo "----------------------------------------"
terraform state show 'module.component["catalogue"].aws_launch_template.main' 2>/dev/null && echo "✓ Catalogue launch template found in state" || echo "✗ Catalogue launch template NOT in state"
terraform state show 'module.component["user"].aws_launch_template.main' 2>/dev/null && echo "✓ User launch template found in state" || echo "✗ User launch template NOT in state"

echo ""
echo "=========================================="
echo "Diagnostic Complete"
echo "=========================================="
