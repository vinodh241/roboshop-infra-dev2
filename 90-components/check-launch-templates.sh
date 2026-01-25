#!/bin/bash
# Script to check existing launch templates in AWS

echo "Checking for launch templates with 'roboshop-dev' in the name..."
echo ""

# Check for catalogue launch template
echo "=== Checking for catalogue launch template ==="
aws ec2 describe-launch-templates --region us-east-1 --query 'LaunchTemplates[?contains(LaunchTemplateName, `roboshop-dev-catalogue`)].{Name:LaunchTemplateName,ID:LaunchTemplateId,DefaultVersion:DefaultVersionNumber,LatestVersion:LatestVersionNumber}' --output table

echo ""
echo "=== Checking for user launch template ==="
aws ec2 describe-launch-templates --region us-east-1 --query 'LaunchTemplates[?contains(LaunchTemplateName, `roboshop-dev-user`)].{Name:LaunchTemplateName,ID:LaunchTemplateId,DefaultVersion:DefaultVersionNumber,LatestVersion:LatestVersionNumber}' --output table

echo ""
echo "=== All launch templates with 'roboshop' in name ==="
aws ec2 describe-launch-templates --region us-east-1 --query 'LaunchTemplates[?contains(LaunchTemplateName, `roboshop`)].{Name:LaunchTemplateName,ID:LaunchTemplateId}' --output table
