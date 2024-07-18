function pyramid=LaplacianPyramid(image, p)
    h_filter = [1, 4, 6, 4, 1]*(1/16);
    g_filter = h_filter' * h_filter * 4;%高斯滤波
   
    pyramid = cell(p, 1);
    handle_image = image;
    
    for i = 1:p - 1
        
        %高斯金字塔构建
        temp = imfilter(handle_image, h_filter, 'replicate');
        rows = size(temp, 1);%查询 temp 的第一个维度的长度
        cols = size(temp, 2);%查询 temp 的第二个维度的长度
        temp = temp(1:2:rows, 1:2:cols, :);%从1到rows和1到cols取值，步长为2
        origin_image = handle_image;
        handle_image = temp;
        
        %拉普拉斯金字塔构建
        temp = UpSampling(handle_image);%上采样，使得上层图像分辨率与下层相等
        temp = temp(1:rows, 1:cols, :);
        temp = imfilter(temp, g_filter, 'replicate');
        e_handle_image = temp;
       
        pyramid{i} = origin_image - e_handle_image;
    end
    pyramid{p} = handle_image;
    
    