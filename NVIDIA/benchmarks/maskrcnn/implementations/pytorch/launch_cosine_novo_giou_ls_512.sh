#!/bin/bash
# this script has novograd + herring

source /shared/novo_herring/bin/activate

BASE_LR=0.06
MAX_ITER=4000
WARMUP_FACTOR=0.000133
WARMUP_ITERS=1000
TRAIN_IMS_PER_BATCH=512
TEST_IMS_PER_BATCH=256
WEIGHT_DECAY=1.25e-3
NSOCKETS_PER_NODE=2
NCORES_PER_SOCKET=24
NPROC_PER_NODE=8
FPN_POST_NMS_TOP_N_TRAIN=1000
OPTIMIZER="NovoGrad"
LR_SCHEDULE="COSINE"
BETA1=0.9
BETA2=0.25
LS=0.1

cd /shared/gautam/training_results_v0.7/NVIDIA/benchmarks/maskrcnn/implementations/pytorch

python tools/train_mlperf.py --config-file 'configs/e2e_mask_rcnn_R_50_FPN_1x_giou_novo_ls.yaml' \
 DTYPE 'float16' \
 PATHS_CATALOG 'maskrcnn_benchmark/config/paths_catalog.py' \
 DISABLE_REDUCED_LOGGING True \
 INPUT.ADD_NOISE True \
 SOLVER.BASE_LR ${BASE_LR} \
 SOLVER.WEIGHT_DECAY ${WEIGHT_DECAY} \
 SOLVER.MAX_ITER ${MAX_ITER} \
 SOLVER.WARMUP_FACTOR ${WARMUP_FACTOR} \
 SOLVER.WARMUP_ITERS ${WARMUP_ITERS} \
 SOLVER.WEIGHT_DECAY_BIAS 0 \
 SOLVER.WARMUP_METHOD linear \
 SOLVER.IMS_PER_BATCH ${TRAIN_IMS_PER_BATCH} \
 SOLVER.OPTIMIZER ${OPTIMIZER} \
 SOLVER.BETA1 ${BETA1} \
 SOLVER.BETA2 ${BETA2} \
 MODEL.RPN.LS ${LS} \
 MODEL.ROI_HEADS.LS ${LS} \
 SOLVER.LR_SCHEDULE ${LR_SCHEDULE} \
 TEST.IMS_PER_BATCH ${TEST_IMS_PER_BATCH} \
 MODEL.RPN.FPN_POST_NMS_TOP_N_TRAIN ${FPN_POST_NMS_TOP_N_TRAIN} \
 NHWC True \
 DATALOADER.NUM_WORKERS 1 \
 SOLVER.CHECKPOINT_PERIOD 230 \
 SAVE_CHECKPOINTS True \
 OUTPUT_DIR '/shared/gautam/carl_checkpoints_32_epoch17_bs512_1' \
 PER_EPOCH_EVAL True

