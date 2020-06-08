#!/bin/sh

image=$1

#docker run -v $(pwd)/test_dir:/opt/ml -p 8080:8080 --rm ${image} serve
singularity exec -B $(pwd)/test_dir:/opt/ml ${image} serve
