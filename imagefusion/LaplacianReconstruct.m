function image=LaplacianReconstruct(laplacian_pyramid)
    h_filter = [1, 4, 6, 4, 1]*(1/16);   
    g_filter = h_filter' * h_filter * 4;%高斯滤波

    laplacian_pyramid_copy = laplacian_pyramid;
    p = length(laplacian_pyramid_copy);%获取金字塔高度
    
    for i = flip(2:p)%i从4到2进行循环，即从金字塔最高层(=可见光和红外光的高斯金字塔最高层相加)开始
        temp = laplacian_pyramid_copy{i};%将该层赋予temp。先将最高层赋予temp
        temp = UpSampling(temp);%上采样
        rows = size(laplacian_pyramid_copy{i-1}, 1);%获得下一层的行数。1代表返回它的行数row
        cols = size(laplacian_pyramid_copy{i-1}, 2);%获得下一层的列数。2代表返回它的列数col
        temp = temp(1:rows, 1:cols, :);%让temp的行，列数与下一层一致
        temp = imfilter(temp, g_filter, 'replicate');%使用高斯核进行卷积。replicate代表边界之外的输入数值假定为等于最近的数组边界值
        laplacian_pyramid_copy{i-1} = laplacian_pyramid_copy{i-1} + temp;%上一层经过上采样和滤波后与当前层相加
    end
    image = laplacian_pyramid_copy{1};%返回第一次层，即融合完成