export DATASET="sumo"

all: prep

info: info_train info_test


info_train:
	@echo "Here are the training params used:"
	@echo "NW: ${NW}"
	@echo "MAX_EPOCH: ${MAX_EPOCH}"
	@echo "BATCH_SIZE: ${BATCH_SIZE}"
	@echo "LR: ${LR}"
	@echo "LR_DECAY: ${LR_DECAY}"


info_test:
	@echo "Here are the testing / training params used:"
	@echo "EPOCH: ${EPOCH}"
	@echo "CHECKPOINT: ${CHECKPOINT}"


train:
	echo "Training"
	time python trainval_net.py --dataset ${DATASET} \
		--net vgg16 \
		--bs ${BATCH_SIZE} --nw ${NW} \
		--lr ${LR} --lr_decay_step ${LR_DECAY} \
		--cuda --mGPUs



test: info_test
	echo "Testing"
	time python test_net.py \
		--dataset ${DATASET} \
		--net vgg16 \
		--checkepoch ${EPOCH} \
		--checkpoint 68973 \
		--cuda