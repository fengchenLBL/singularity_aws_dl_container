## Text Classification Using AWS Deep Learning Docker Containers

A modified version of this AWS SageMaker lab guide: https://github.com/aws-samples/amazon-sagemaker-keras-text-classification

* ### [Building the Singularity container using available aws deep learning docker containers](./singularity_docker.ipynb)  
* ### Local Test:
  ```shell
  cd container
  sh build_singularity_local_test.sh
  ```
* ### Train text classifier on Lawrencium
  * Upload the Singularity image and traning data
    ```shell
    sftp lrc-xfer.lbl.gov
    put local_sagemaker-keras-text-classification.sif
    put -r local_test
    ```
  * Run the Singularity image on Lawrencium compute-node
    ```shell
    ssh lrc-login.lbl.gov
    cd local_test
    srun  -N 1 -p lr4 -A $ACCOUNT -t 1:0:0 -q lr_normal --pty bash
    sh train_local.sh ../local_sagemaker-keras-text-classification.sif
    ```

## Citations
1. https://aws.amazon.com/releasenotes/available-deep-learning-containers-images
1. https://github.com/aws-samples/amazon-sagemaker-keras-text-classification
1. https://github.com/lbnl-science-it/aws-sagemaker-keras-text-classification
1. https://sylabs.io/guides/3.5/user-guide/
