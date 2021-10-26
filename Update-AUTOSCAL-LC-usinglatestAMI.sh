#!/bin/bash
#id=`aws ec2 describe-images --owners 986811428101 --filters --query 'sort_by(Images, &CreationDate)[*].ImageId' --output text`

#aws ec2 run-instances \
#    --image-id  $id \
#    --instance-type t2.micro \
#    --key-name kube



#============FINAL UPDATED WORKING CODE FOR CREATING AMI AND UPDATING IN AUTOSCALING LANCH CONFIG============

#!/bin/bash

echo -n "what is version? "

read ver

echo "Latest version is $ver"

day=$(date +"%d%m%Y-%H%M%p")

image_id=$(aws ec2 create-image --instance-id i-029ecc92c10692983 --name "VfPlay-API_$ver-LC-U16_$day" --description "VfPlay-API_$ver-LC-U16_$day" --no-reboot --query ImageId --output text)

echo "Ami creating with Ami-Id = $image_id"

aws ec2 create-tags --resources $image_id --tags Key=Name,Value=TestImage-$day-LC

sleep 5m

echo "Creating Lanch Configuration.....!"

aws autoscaling create-launch-configuration \
--launch-configuration-name VfPlay-API_$ver-LC-U16_$day \
--image-id $image_id \
--instance-type c5.2xlarge \
--iam-instance-profile api-instance-role \
--instance-monitoring Enabled=true \
--block-device-mappings '[{"DeviceName":"/dev/sdb","Ebs":{"VolumeSize":120,"VolumeType":"gp2","DeleteOnTermination": true}}]'
--security-groups sg-63ee6208 \
--key-name vodaott-aws \

