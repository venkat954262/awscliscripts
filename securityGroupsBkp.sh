#Grab all the security group info for this region in one call.
aws ec2 describe-security-groups --output text > /root/aws-sec-groups.txt

#we can specify region
aws ec2 describe-security-groups --region $REGION --output text > /root/aws-sec-groups.txt

#Grab list of actively used security groups for EC2.
aws ec2 describe-instances --query 'Reservations[*].Instances[*].SecurityGroups[*].GroupId' \
       	--output text --region $REGION | tr '\t' '\n' | sort | uniq > /root/aws-sec-grp-ec2.txt

#Grab list of actively used security groups for RDS.
aws rds describe-db-security-groups --query 'DBSecurityGroups[*].EC2SecurityGroups[*].EC2SecurityGroupId' --output text --region $REGION | tr '\t' '\n' | sort | uniq > /root/aws-sec-group-rds



