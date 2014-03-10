clearvars, close all

load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

%scatter3_kinectxyzrgb(frames{1})


frame1 = frames{1};

show_rgb_image(frame1);


show_scatter_image(frame1);

show_depth_image(frame1);