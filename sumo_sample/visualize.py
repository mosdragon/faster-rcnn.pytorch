import numpy as np

import os
import pickle
import cv2

# Color
GREEN = (0, 255, 0)

font = cv2.FONT_HERSHEY_SIMPLEX

with open("annotations.pkl", "rb") as f:
    data = pickle.load(f)


for imgname, bboxes in data.items():

    filename = os.path.join("input_images", imgname) + ".jpg"
    img = cv2.imread(filename)

    for bbox in bboxes:
        xmin, ymin, xmax, ymax = bbox['bbox']

        img = cv2.rectangle(img, (xmin, ymin), (xmax, ymax), GREEN, 3)

        label = bbox['name']
        # org, fontFace, fontScale, color
        cv2.putText(img, label, (xmin + 10, ymin + 10), font, 0.4, GREEN)


    outname = os.path.join("output_images", imgname) + ".jpg"
    print("OUTNAME: ", outname)
    cv2.imwrite(outname, img)
