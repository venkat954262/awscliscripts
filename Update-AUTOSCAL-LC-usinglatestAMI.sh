#!/bin/bash
#id=`aws ec2 describe-images --owners 986811428101 --filters --query 'sort_by(Images, &CreationDate)[*].ImageId' --output text`

#aws ec2 run-instances \
#    --image-id  $id \
#    --instance-type t2.micro \
#    --key-name kube



#============FINAL UPDATED WORKING CODE FOR CREATING AMI AND UPDATING IN AUTOSCALING LANCH CONFIG============

#!/bin/bash

image_id=$(aws ec2 create-image --instance-id i-02240db58d7a3f905 --name "MyTestAMI" --description "An AMI for my Testserver" --no-reboot --query ImageId --output text)

echo "created image id is $image_id"

day=$(date +"%d%m%Y")

aws ec2 create-tags --resources $image_id --tags Key=Name,Value=TestImage-$day-LC


sleep 7m


aws autoscaling create-launch-configuration \
--launch-configuration-name TestLanch-$day \
--key-name TeskKey \
--image-id $image_id \
--security-groups sg-eb2af88e \
--instance-type t2.macro \
--instance-monitoring Enabled=true \
--iam-instance-profile my-autoscaling-role
