clearvars, close all

load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

%scatter3_kinectxyzrgb(frames{1})

figure_rgb = 1;
figure_depth = 2;



%{
for i=1:20,
    frame = frames{i};
    show_rgb_image(frame, figure_rgb);
    hold on;
    pause(0.5);
end
%}

disp('Press key to continue with depth image');
%pause;

for i=1:20,
    frame = frames{i};
    show_depth_image(frame, figure_depth);
    hold on;
    pause();
end


%show_rgb_image(frame1);
%show_scatter_image(frame1);
%show_depth_image(frame1);

