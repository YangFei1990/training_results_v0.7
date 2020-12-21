#!/bin/bash
BASE_LR=0.008
MAX_ITER=45000
WARMUP_FACTOR=0.0001
WARMUP_ITERS=100
TRAIN_IMS_PER_BATCH=8
TEST_IMS_PER_BATCH=8
WEIGHT_DECAY=5e-4
OPTIMIZER="NovoGrad"
LR_SCHEDULE="COSINE"
BETA1=0.9
BETA2=0.4

mpirun --allow-run-as-root -np 8 python tools/train_mlperf.py --config-file 'configs/e2e_mask_rcnn_R_50_FPN_1x.yaml' \
 SAVE_CHECKPOINTS True \
 DTYPE 'float16' \
 PER_EPOCH_EVAL False \
 PATHS_CATALOG 'maskrcnn_benchmark/config/paths_catalog.py' \
 DISABLE_REDUCED_LOGGING True \
 SOLVER.BASE_LR ${BASE_LR} \
 SOLVER.WEIGHT_DECAY ${WEIGHT_DECAY} \
 SOLVER.MAX_ITER ${MAX_ITER} \
 SOLVER.WARMUP_FACTOR ${WARMUP_FACTOR} \
 SOLVER.WARMUP_ITERS ${WARMUP_ITERS} \
 SOLVER.WEIGHT_DECAY_BIAS 0 \
 SOLVER.WARMUP_METHOD mlperf_linear \
 SOLVER.IMS_PER_BATCH ${TRAIN_IMS_PER_BATCH} \
 SOLVER.OPTIMIZER ${OPTIMIZER} \
 SOLVER.BETA1 ${BETA1} \
 SOLVER.BETA2 ${BETA2} \
 SOLVER.LR_SCHEDULE ${LR_SCHEDULE} \
 TEST.IMS_PER_BATCH ${TEST_IMS_PER_BATCH} \
 NHWC True

