#!/bin/bash

# Runs scan completion with hierarchical model over a set of scenes.

# Parameter section begins here. Edit to change number of test scenes, which model to use, output path.
MAX_NUM_TEST_SCENES=1
NUM_HIERARCHY_LEVELS=1
BASE_OUTPUT_DIR=./vis

# Fill in path to test scenes
TEST_SCENES_PATH_1='.'

# Fill in model to use here
PREDICT_SEMANTICS=1
HIERARCHY_LEVEL_3_MODEL='../completion-semantics/hierarchy3of3/model.ckpt'

# Specify output folders for each hierarchy level.
OUTPUT_FOLDER_3=${BASE_OUTPUT_DIR}/vis_level3

# End parameter section.

# Run hierarchy.

# ------- hierarchy level 3 ------- #

IS_BASE_LEVEL=1
HIERARCHY_LEVEL=3
HEIGHT_INPUT=64

# go thru all test scenes
count=1
for scene in $TEST_SCENES_PATH_1/*.tfrecords; do
  echo "Processing hierarchy level 3, scene $count of $MAX_NUM_TEST_SCENES: $scene".
  python complete_scan.py \
    --alsologtostderr \
    --model_checkpoint="${HIERARCHY_LEVEL_3_MODEL}" \
    --height_input="${HEIGHT_INPUT}" \
    --hierarchy_level="${HIERARCHY_LEVEL}" \
    --num_total_hierarchy_levels="${NUM_HIERARCHY_LEVELS}" \
    --is_base_level="${IS_BASE_LEVEL}" \
    --predict_semantics="${PREDICT_SEMANTICS}" \
    --output_folder="${OUTPUT_FOLDER_3}" \
    --input_scene="${scene}"
  ((count++))
  if (( count > MAX_NUM_TEST_SCENES )); then
    break
  fi
done


