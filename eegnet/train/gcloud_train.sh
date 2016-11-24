#!/bin/bash

# Quit early if any command fails.
set -ex

JOB_NAME=eegnet_distributed_${USER}_$(date +%Y%m%d_%H%M%S)
PROJECT_ID=`gcloud config list project --format "value(core.project)"`
TRAIN_BUCKET=gs://${PROJECT_ID}-ml
TRAIN_PATH=${TRAIN_BUCKET}/${JOB_NAME}

gcloud beta ml jobs submit training ${JOB_NAME} \
  --package-path=trainer \
  --module-name=trainer.task \
  --staging-bucket="${TRAIN_BUCKET}" \
  --region=us-east1 \
  --config=config_gcloud.yaml \
  -- \
  --dataset_dir="${TRAIN_BUCKET}/train/*.tfr" \
  --log_dir="${TRAIN_PATH}" \
  --batch_size=3 \
  --num_splits=1 \
  --num_iters=5000
