#!/bin/bash
#id=`aws ec2 describe-images --owners 986811428101 --filters --query 'sort_by(Images, &CreationDate)[*].ImageId' --output text`

#aws ec2 run-instances \
#    --image-id  $id \
#    --instance-type t2.micro \
#    --key-name kube



#============FINAL UPDATED WORKING CODE FOR CREATING AMI AND UPDATING IN AUTOSCALING LANCH CONFIG============

#!/bin/bash


day=$(date +"%d%m%Y-%H%M%p")

echo -n "what is version? "

read ver

echo "Latest version is VfPlay-API_$ver-LC-U16_$day"

echo "Creating AMI...!"

image_id=$(aws ec2 create-image --instance-id i-029ecc92c10692983 --name "VfPlay-API_$ver-LC-U16_$day" --description "VfPlay-API_$ver-LC-U16_$day" --no-reboot --query ImageId --output text)

aws ec2 create-tags --resources $image_id --tags Key=Name,Value=VfPlay-API_$ver-LC-U16_$day

while true; do
AmiState=$(/usr/local/bin/aws ec2 describe-images --image-ids $image_id  | grep State | awk '{print $2}' | xargs | tr -d ',')
if [ "$AmiState" == "available" ]; then

	break

	else

	echo "" &> /dev/null

fi

sleep 30

done

echo "Ami created with Ami-Id = $image_id"

echo "Creating Lanch Configuration.....!"

snap1_id=$(/usr/local/bin/aws ec2 describe-images --image-ids $image_id | grep "SnapshotId" | awk 'FNR == 1 {print $2}'| xargs | tr -d ',')
snap2_id=$(/usr/local/bin/aws ec2 describe-images --image-ids $image_id | grep "SnapshotId" | awk 'FNR == 2 {print $2}'| xargs | tr -d ',')

aws autoscaling create-launch-configuration \
--launch-configuration-name VfPlay-API_$ver-LC-U16_$day \
--image-id $image_id \
--instance-type c5.2xlarge \
--instance-monitoring Enabled=true \
--block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"SnapshotId":$snap1_id,"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}},
                          {"DeviceName":"/dev/sdb","Ebs":{"SnapshotId":$snap2_id,"VolumeSize":120,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
--security-groups sg-63ee6208 \
--key-name vodaott-aws \

echo "Lanch Configuration created --update in ASG now"




