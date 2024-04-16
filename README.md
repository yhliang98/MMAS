# MMAS
Mouse motion analysis system for Morris water maze tests

MMAS consists of two parts: pose estimation and motion analysis. 
Before further processing, please make sure the frame rate of the videos is uniform.

## Pose estimation
We trained our deep convolutional neural network on [Deeplabcut](https://www.nature.com/articles/s41593-018-0209-y). For more details on implementation, please [click here](https://github.com/DeepLabCut/DeepLabCut). 

Our settings can be found in [config.yaml](MMAS/config.yaml).
The snapeshots of our model can be downloaded from this [google drive link](https://drive.google.com/drive/folders/11-P8tfpumooU8yvgD4gXxcatPxpJPDif?usp=drive_link).
You could try it on your videos and get .csv files, containing the tracking results of key points with both coordinates and likelihood, for next module.

## Motion analysis
This module allows us to conduct behavior and motion analysis from previous results with one click. The output includes escape latency, trajectory length, speed, head turning angles, tail wagging angles, body lengths and etc. They are all summarized into an Excel file. Details could be found in [watermaze.m](MMAS/watermaze.m). Don't forget to change the path to your previous output.

## Cognitive score
[Cognitive score](https://www.nature.com/articles/s41598-022-09270-1) is calculated based on search strategies, which are determined by [Pathfinder](https://f1000research.com/articles/8-1521/v2). For more details on implementation, please [click here](https://github.com/MatthewBCooke/Pathfinder)
