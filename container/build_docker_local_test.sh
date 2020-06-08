#!/bin/sh
####################################################
########## Download and unzip the dataset ##########
####################################################
cd ../data/
wget https://danilop.s3-eu-west-1.amazonaws.com/reInvent-Workshop-Data-Backup.zip && unzip reInvent-Workshop-Data-Backup.zip
mv reInvent-Workshop-Data-Backup/* ./
rm -rf reInvent-Workshop-Data-Backup reInvent-Workshop-Data-Backup.zip
cd ../container/

###################################################################################
######### Build the SageMaker Container & Convert it to Singularity image #########
###################################################################################
algorithm_name=sagemaker-keras-text-classification

chmod +x sagemaker_keras_text_classification/train
chmod +x sagemaker_keras_text_classification/serve

# Get the region defined in the current configuration

fullname="local_${algorithm_name}:latest"

# Get the login command from ECR and execute it directly
$(aws ecr get-login --no-include-email --region ${region} --registry-ids 763104351884)

# Build the docker image locally with the image name
# In the "Dockerfile", modify the source image to select one of the available deep learning docker containers images:
# https://aws.amazon.com/releasenotes/available-deep-learning-containers-images
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
#./serve_local.sh ../${fullname}
