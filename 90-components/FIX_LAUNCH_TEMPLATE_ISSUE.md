# Fix: Launch Template Already Exists Error

## Problem
The error occurs because launch templates `roboshop-dev-catalogue` and `roboshop-dev-user` already exist in AWS, but Terraform doesn't have them in its state file. When Terraform tries to create them, AWS rejects the request because the names are already in use.

**However**, if you get "Cannot import non-existent remote object", it means the launch templates don't actually exist in AWS, which suggests a different issue.

## Root Cause
There are two possible scenarios:

### Scenario 1: Launch Templates Exist in AWS but Not in State
- Launch templates were created previously (either manually or from a previous Terraform run)
- Terraform state doesn't include these resources
- Terraform tries to create them again, causing the conflict

### Scenario 2: Launch Templates in State but Not in AWS (Orphaned State)
- Launch templates exist in Terraform state but were deleted from AWS
- Terraform thinks they exist and tries to manage them
- This causes conflicts when trying to create new ones

## Solution 1: Check What Actually Exists

First, let's verify what's in AWS and what's in Terraform state:

### Step 1: Check AWS for Existing Launch Templates
Run this command to see all launch templates:
```bash
aws ec2 describe-launch-templates --region us-east-1 --query 'LaunchTemplates[?contains(LaunchTemplateName, `roboshop`)].{Name:LaunchTemplateName,ID:LaunchTemplateId}' --output table
```

Or use the provided script:
```bash
chmod +x check-launch-templates.sh
./check-launch-templates.sh
```

### Step 2: Check Terraform State
```bash
cd roboshop-infra-dev2/90-components
terraform state list | grep launch_template
```

## Solution 2: If Launch Templates DON'T Exist in AWS

If the launch templates don't exist in AWS, but Terraform state has them (orphaned state), remove them from state:

```bash
# Remove from state if they exist there
terraform state rm 'module.component["catalogue"].aws_launch_template.main' 2>/dev/null || true
terraform state rm 'module.component["user"].aws_launch_template.main' 2>/dev/null || true
```

Then run:
```bash
terraform plan
terraform apply
```

## Solution 3: If Launch Templates DO Exist in AWS

If they exist in AWS, import them (but use the correct ID format):

### Step 1: Run Diagnostic Script
First, run the diagnostic script to understand the exact situation:
```bash
cd roboshop-infra-dev2/90-components
chmod +x diagnose-issue.sh
./diagnose-issue.sh
```

### Step 2: Based on Diagnostic Results

**If launch templates exist in AWS but NOT in Terraform state:**

Get the launch template IDs:
```bash
# Get catalogue launch template ID
CATALOGUE_ID=$(aws ec2 describe-launch-templates --launch-template-names roboshop-dev-catalogue --region us-east-1 --query 'LaunchTemplates[0].LaunchTemplateId' --output text 2>/dev/null)

# Get user launch template ID  
USER_ID=$(aws ec2 describe-launch-templates --launch-template-names roboshop-dev-user --region us-east-1 --query 'LaunchTemplates[0].LaunchTemplateId' --output text 2>/dev/null)

echo "Catalogue ID: $CATALOGUE_ID"
echo "User ID: $USER_ID"
```

Then import using the ID (not the name):
```bash
terraform import 'module.component["catalogue"].aws_launch_template.main' $CATALOGUE_ID
terraform import 'module.component["user"].aws_launch_template.main' $USER_ID
```

**If launch templates DON'T exist in AWS:**

Remove them from Terraform state if they're there:
```bash
terraform state rm 'module.component["catalogue"].aws_launch_template.main' 2>/dev/null || true
terraform state rm 'module.component["user"].aws_launch_template.main' 2>/dev/null || true
```

Then proceed with normal apply.

### Step 5: Verify the Import
Check that the resources are now in state:
```bash
terraform state list | grep launch_template
```

You should see:
- `module.component["catalogue"].aws_launch_template.main`
- `module.component["user"].aws_launch_template.main`

### Step 6: Run Terraform Plan
```bash
terraform plan
```

This should now show that Terraform will update the existing launch templates instead of trying to create new ones.

### Step 7: Apply Changes (if plan looks good)
```bash
terraform apply
```

## Solution 4: Use Name Prefix Instead of Fixed Name (Recommended for Future)

If you continue to have naming conflicts, modify the module to use `name_prefix` instead of `name`. However, since you're using a module from GitHub, you'll need to either:

1. Fork the module and modify it
2. Use a local module path instead of GitHub
3. Contact the module maintainer

## Alternative Solution: Delete Existing Launch Templates (Use with Caution)

⚠️ **WARNING**: Only use this if the launch templates are not being used by any Auto Scaling Groups or EC2 instances.

If you want to delete the existing launch templates and let Terraform create new ones:

### Step 1: Check if Launch Templates are in Use
```bash
# Check for Auto Scaling Groups using these templates
aws autoscaling describe-auto-scaling-groups --region us-east-1 --query 'AutoScalingGroups[?contains(LaunchTemplate.LaunchTemplateName, `roboshop-dev-catalogue`) || contains(LaunchTemplate.LaunchTemplateName, `roboshop-dev-user`)].{Name:AutoScalingGroupName,LaunchTemplate:LaunchTemplate.LaunchTemplateName}' --output table
```

### Step 2: Delete Launch Templates (if not in use)
```bash
aws ec2 delete-launch-template --launch-template-name roboshop-dev-catalogue --region us-east-1
aws ec2 delete-launch-template --launch-template-name roboshop-dev-user --region us-east-1
```

### Step 3: Run Terraform Apply
```bash
terraform apply
```

## Prevention for Future

To prevent this issue in the future, consider:

1. **Always use Terraform for resource creation** - Don't create AWS resources manually that Terraform manages
2. **Use Terraform workspaces** - Separate state files for different environments
3. **Add lifecycle rules** - Consider adding `create_before_destroy` lifecycle blocks (though this won't help with the initial creation issue)
4. **Use unique naming** - Add timestamps or random suffixes if needed

## Troubleshooting

### If Import Fails
- Make sure you're in the correct directory (`90-components`)
- Verify the launch template names exactly match: `roboshop-dev-catalogue` and `roboshop-dev-user`
- Check that your AWS credentials are configured correctly
- Ensure you're using the correct AWS region (us-east-1 based on your provider config)

### If Launch Templates are Used by ASG
If the launch templates are being used by Auto Scaling Groups, you'll need to:
1. First import/update the Auto Scaling Groups
2. Then import the launch templates
3. Or delete the ASGs first, then delete and recreate the launch templates
