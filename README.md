# awscliscripts
#cmd to get all private ips in an AUTOSCALING GROUP
aws ec2 describe-instances --region ap-south-1 --instance-ids $(aws autoscaling describe-auto-scaling-instances --region ap-south-1 --output text --query "AutoScalingInstances[?AutoScalingGroupName=='API_VfPlay_ASG'].InstanceId") --query "Reservations[].Instances[].PrivateIpAddress" | jq -r '.[]'

####ansible aws dynamic inventory ###
https://github.com/Josh-Tracy/ansible-dynamic-inventory-ec2
