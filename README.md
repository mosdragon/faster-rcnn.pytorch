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


## Use the Virtualenv
```bash
source frcnn_venv/bin/activate
```

### Set ENV Vars
```bash
export DATASET="pascal_voc"  # We symlinked sumo as pascal earlier.
export BATCH_SIZE=4
export NW=4  # Set this to number of GPUs. 4 works well for Skynet.
export LR="1e-3"
export LR_DECAY="5"
export MAX_EPOCHS="9"  # This should take 48 hours.
```

We get a model built that we can run anytime after each epoch (about 5 hours each). We can set `$MAX_EPOCH` to something large above, and use model from Epoch `5` or something and let the network continue training behind the scenes unless we have no more GPUs to use for inference.


### Begin Training
```bash
echo "Training"
time python trainval_net.py --dataset ${DATASET} \
  --net vgg16 \
  --bs ${BATCH_SIZE} --nw ${NW} \
  --lr ${LR} --lr_decay_step ${LR_DECAY} \
  --epochs ${MAX_EPOCHS}
  --cuda
```

Once this is running, we can go back and generate the `test` partitions in the SUMO dataset. Those will be useful to us later.

### After Training
As each epoch finishes, we will find a trained model file under `models/pascal_voc/vgg16/faster_rcnn_${session}_${epoch}_${step}.pth`. This is a model we can then use to train.


### Using a Small Sample for Training
Anytime we modify our training data, me must remove the cache this repo creates.
```bash
cd data/cache/
# You will see something like pascal_voc2007_train.pkl. Delete that file.
```

We can just create new temporary `train.txt` and `trainval.txt` files.
```bash
cd /path/to/dataset_sumo
cd ImageSets/Main

# Backup the full size train/trainval file.
mkdir backup
cp train.txt backup/
cp trainval.txt backup/

# Take first 100 samples from train/trainval files.
head -n 100 backup/train.txt > train.txt
head -n 100 backup/trainval.txt > trainval.txt
```

Now run the training steps above. Undo these steps and delete cache again when done experimenting with small sample size.
