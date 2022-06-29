#SHELL SCRIPT FOR GETTING PRIVATE IP's OF AUTOSCALING GROUP INSTANCES ----change ASGNAME and region
#=====================================================================================================
day=$(date +%d%h%H%M)
da=$(date +%d%h%H%M%S)

aws autoscaling describe-auto-scaling-instances --region ap-south-1 --output text   --query "AutoScalingInstances[?AutoScalingGroupName=='ABHI-ASG'].InstanceId" | xargs -n1 aws ec2 describe-instances --instance-ids $ID --region ap-south-1  --query "Reservations[].Instances[].PrivateIpAddress" --output text  >> iplist-$day.txt

sed '$!s/$/,/' iplist-$day.txt |  tr -d '\n' >> updatedips-$da.txt

#===========================Updated script in FOR LOOP ==============================
for i in `aws autoscaling describe-auto-scaling-instances --region ap-south-1 --output text   --query "AutoScalingInstances[?AutoScalingGroupName=='API_VfPlay_ASG']" | grep False | awk '{print $4}'`
do
aws ec2 describe-instances --instance-ids $i --region ap-south-1  --query "Reservations[].Instances[].PrivateIpAddress" --output text
done;

