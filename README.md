# A *Faster* Pytorch Implementation of Faster R-CNN

### Download Repo:
```bash
git clone https://github.com/mosdragon/faster-rcnn.pytorch
cd faster-rcnn.pytorch
```

### Compile Cuda Code
```bash
cd lib
bash make.sh  # If it crashes, modify the $CUDA_PATH
```

### Download Pre-trained VGG16 Network
```bash
mkdir -p data/pretrained_model/
wget https://filebox.ece.vt.edu/~jw2yang/faster-rcnn/pretrained-base-models/vgg16_caffe.pth -O data/pretrained_model/vgg16_caffe.pth
```

### Setup faster-rcnn to work with SUMO
```bash
cd data
mkdir VOCdevkit2007
ln -s /path/to/dataset_sumo VOCdevkit2007/VOC2007
```

### Install Dependencies
```bash
python3 -m venv frcnn_venv
source frcnn_venv/bin/activate

pip install -r requirements.txt
```


## Training:
__Note:__ Run this inside `tmux` or `screen`.

### Set ENV Vars
```bash
export DATASET="pascal_voc"  # We symlinked sumo as pascal earlier.
export BATCH_SIZE=4
export NW=4  # Set this to number of GPUs. 4 works best overall
export LR="1e-3"
export LR_DECAY="5"
```

### Begin Training
```bash
echo "Training"
time python trainval_net.py --dataset ${DATASET} \
  --net vgg16 \
  --bs ${BATCH_SIZE} --nw ${NW} \
  --lr ${LR} --lr_decay_step ${LR_DECAY} \
  --cuda
```

Once this is running, we can go back and generate the `test` partitions in the SUMO dataset. Those will be useful to us later.
