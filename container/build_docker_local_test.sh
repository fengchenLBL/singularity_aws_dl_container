#!/bin/sh
####################################################
########## Download and unzip the dataset ##########
####################################################
cd ../data/
wget https://danilop.s3-eu-west-1.amazonaws.com/reInvent-Workshop-Data-Backup.zip && unzip reInvent-Workshop-Data-Backup.zip
mv reInvent-Workshop-Data-Backup/* ./
rm -rf reInvent-Workshop-Data-Backup reInvent-Workshop-Data-Backup.zip
cd ../container/

#################################################
######### Buildi the SageMaker Container ########
#################################################
algorithm_name=sagemaker-keras-text-classification

chmod +x sagemaker_keras_text_classification/train
chmod +x sagemaker_keras_text_classification/serve

#account=$(aws sts get-caller-identity --query Account --output text)

# Get the region defined in the current configuration (default to us-west-2 if none defined)
region=$(aws configure get region)
#region=${region:-us-west-2}

fullname="local_${algorithm_name}:latest"

# Get the login command from ECR and execute it directly
#$(aws ecr get-login --region ${region} --no-include-email)
$(aws ecr get-login --no-include-email --region ${region} --registry-ids 763104351884)

# Build the docker image locally with the image name and then push it to ECR
docker build  -t ${algorithm_name} .
docker tag ${algorithm_name} ${fullname}

# Build Singularity image from local docker image
sifname="local_sagemaker-keras-text-classification.sif"
sudo singularity build ${sifname} docker-daemon:${fullname}


################################
########## Local Test ########## 
################################
cd ../data
cp -a . ../container/local_test/test_dir/input/data/training/
cd ../container
cd local_test

### Train
./train_local.sh ../${sifname}

### Prediction
#./serve_local.sh ${fullname}
