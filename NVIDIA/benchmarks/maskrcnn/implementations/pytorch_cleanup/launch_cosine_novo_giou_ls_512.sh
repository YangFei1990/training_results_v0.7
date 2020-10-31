#!/bin/bash
source /shared/herring_mzanur/bin/activate
echo $LD_LIBRARY_PATH
echo $PATH

BASE_LR=0.04
MAX_ITER=4000
WARMUP_FACTOR=0.0133
WARMUP_ITERS=500
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

#cd /shared/mzanur/training_results_v0.7/NVIDIA/benchmarks/maskrcnn/implementations/pytorch_cleanup

/shared/herring_mzanur/bin/python -u -m bind_launch --nnodes 32 --node_rank $OMPI_COMM_WORLD_RANK --master_addr 192.168.69.5 --master_port 1234 --nsockets_per_node=${NSOCKETS_PER_NODE} \
 --ncores_per_socket=${NCORES_PER_SOCKET} --nproc_per_node=${NPROC_PER_NODE} \
 tools/train_mlperf.py --config-file 'configs/e2e_mask_rcnn_R_50_FPN_1x_giou_novo_ls.yaml' \
 DTYPE 'float16' \
 PATHS_CATALOG 'maskrcnn_benchmark/config/paths_catalog.py' \
 DISABLE_REDUCED_LOGGING True \
 INPUT.ADD_NOISE False \
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
 NHWC True

