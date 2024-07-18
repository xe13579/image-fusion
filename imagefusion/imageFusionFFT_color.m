function fused_image = imageFusionFFT_color(image1, image2)
  % 获取图像大小
  [rows, cols, ~] = size(image1);

  % 对每个颜色通道进行傅里叶变换
  for channel = 1:3
    fft_image1_channel = fft2(image1(:,:,channel));
    fft_image2_channel = fft2(image2(:,:,channel));

    % 计算频谱
    spectrum_image1_channel = abs(fft_image1_channel);
    spectrum_image2_channel = abs(fft_image2_channel);

    [a1, b1, c1] = size(spectrum_image1_channel);
    mask =double(ones(a1, b1, c1)*0.5);
    % 合并两个图像的频谱
    fused_spectrum_channel = mask .* fft_image1_channel + mask .* fft_image2_channel;

    % 进行逆傅里叶变换
    fused_image_channel = ifft2(fused_spectrum_channel);

    % 将结果存储到融合图像的对应通道
    fused_image(:,:,channel) = uint8(real(fused_image_channel));
  end


end