function up_image=UpSampling(image)%上采样，使得上层图像分辨率与下层相等
    [rows, cols, channels] = size(image);
    up_image = double(zeros(rows*2, cols*2, channels));
    up_image(1:2:rows*2, 1:2:cols*2, :) = image;