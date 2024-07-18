% 小波变换实现红外与可见光图像融合
clc;
clear ;
close ;
% 读取红外光图像
IR = double(imread('your own path\\IR\\IR.bmp'));
% 读取可见光图像
VI = double(imread('your own path\\VI\\VI.bmp'));
% 对红外和可见光图像进行小波变换,离散小波变换函数dwt2()
%1，2，3，4分别是低频信息，水平方向的高频信息，竖直方向的高频信息，对角线方向的高频信息
[IR1, IR2, IR3, IR4] = dwt2(IR, 'haar');%haar,db1,sym2,sym4。
[VI1, VI2, VI3, VI4] = dwt2(VI, 'haar');
 
      fused_IR1 = imageFusionFFT_color(IR1, VI1);
      fused_IR2 = imageFusionFFT_color(IR2, VI2);
      fused_IR3 = imageFusionFFT_color(IR3, VI3);
      fused_IR4 = imageFusionFFT_color(IR4, VI4);
     fused_image = idwt2(fused_IR1, fused_IR2, fused_IR3, fused_IR4, 'haar');
% 对小波系数进行融合
%ffttlalala=imageFusionFFT_color(IR,VI);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%第一种方法，平均融合
fusion1=(IR1 + VI1)/2;%图像的低频信息，刻画原始图像的逼近信息
fusion2=(IR2 + VI2)/2;%图像水平方向的高频信息，刻画原始图像的横向细节
fusion3=(IR3 + VI3)/2;%图像竖直方向的高频信息，刻画原始图像的垂直细节
fusion4=(IR4 + VI4)/2;%图像在对角线方向的高频信息，刻画原始图像的对角线上的细节

c1 = max(abs(IR1), abs(VI1));%第二种方法选择子带能量较大的部分
c2 = max(abs(IR2), abs(VI2));
c3 = max(abs(IR3), abs(VI3));
c4 = max(abs(IR4), abs(VI4));

%第三种方法，傅里叶融合方法
       fused_IR1 = imageFusionFFT_color(IR1, VI1);
      fused_IR2 = imageFusionFFT_color(IR2, VI2);
      fused_IR3 = imageFusionFFT_color(IR3, VI3);
      fused_IR4 = imageFusionFFT_color(IR4, VI4);
    

%第四种，区域能量
q1=fenergyy(IR1,VI1);
q2=fenergyy(IR2,VI2);
q3=fenergyy(IR3,VI3);
q4=fenergyy(IR4,VI4);


% 对融合后的小波系数进行逆变换
blendImage = idwt2(fusion1, fusion2, fusion3, fusion4, 'haar');%1
blendImagesym4 = idwt2(c1, c2, c3, c4, 'haar');%2
fused_image = idwt2(fused_IR1, fused_IR2, fused_IR3, fused_IR4, 'haar');%3
qqq=idwt2(q1, q2, q3, q4, 'haar');%4
% 显示红外和可见光和融合图像
figure(1);
subplot(1, 3, 1);
imshow(uint8(IR));%图像是uint8类型
title('红外光图像');
subplot(1, 3, 2);
imshow(uint8(VI));
title('可见光图像');
subplot(1, 3, 3);
imshow(uint8(blendImage));
title('平均算法最终融合图像');
figure(2);
imshow(uint8(blendImagesym4));
title('能量较大算法融合图像');
figure(3);
imshow(uint8(blendImage));
title('平均算法最终融合图像');

figure(4);
imshow(uint8(fused_image));
title('傅里叶方法融合图像');

figure(5);
imshow(qqq);
title('区域融合算法融合图像');

% 保存融合后的图像
imwrite(uint8(blendImage), 'waveletfusion.bmp');
imwrite(uint8(blendImagesym4), 'waveletfusion2.bmp');
imwrite(uint8(fused_image), 'waveletfusion3.bmp');
imwrite((qqq), 'waveletfusion4.bmp');


%%%%%%%%%%峰值信噪比%%%%%%%%%
%PSNR 衡量的是：原始图像与融合图像中的实际信号之间的平均平方误差
%PSNR 的值越高，表示融合图像与原始图像之间的失真越小，图像质量越好
ir1 = imread('your own path\\IR\\IR.bmp');
vi1 = imread('your own path\\VI\\VI.bmp');
a=imread('your own path\\waveletfusion4.bmp');
IR_psnr = psnr(ir1, a);
VI_psnr = psnr(vi1, a);
disp(['红外光与融合图峰值信噪比: ' num2str(IR_psnr)]);
disp(['可见光与融合图峰值信噪比: ' num2str(VI_psnr)]);
%%%%%%%%%%峰值信噪比%%%%%%%%%


%%%%%%%%%%%%交叉熵%%%%%%%%%%%%%%%%%%%%
% 导入图像
sourceImage1 = imread('your own path\\IR\\IR.bmp');
sourceImage2 = imread('your own path\\VI\\VI.bmp');
aa=imread('your own path\\waveletfusion4.bmp');
sourceImagef = aa;
% 将图像数据转换为概率分布
% 使用 histcounts 函数计算每个像素值的出现次数
[counts1, edges1] = histcounts(sourceImage1(:), 256);
[counts2, edges2] = histcounts(sourceImage2(:), 256);
[countsf, edgesf] = histcounts(sourceImagef(:), 256);
% 将出现次数转换为概率
prob1 = counts1 / sum(counts1);
prob2 = counts2 / sum(counts2);
probf = countsf / sum(countsf);
% 计算交叉熵
CE1 = crossentropy(prob1, probf);
CE2 = crossentropy(prob2, probf);
% 显示结果
disp(['红外光与融合图交叉熵: ' num2str(CE1)]);
disp(['可见光与融合图交叉熵: ' num2str(CE2)]);
%%%%%%%%%%%%交叉熵%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%结构相似度%%%%%%%%%%
aaa1 = imread('your own path\\IR\\IR.bmp');
aaa2 = imread('your own path\\VI\\VI.bmp');
aaa=imread('your own path\\waveletfusion4.bmp');
SSIM1 = ssim(aaa1, aaa);
SSIM2 = ssim(aaa2, aaa);
disp(['红外光与融合图结构相似度: ' num2str(SSIM1)]);
disp(['可见光与融合图结构相似度: ' num2str(SSIM2)]);
%%%%%%%%%%%结构相似度%%%%%%%%%%


%%%%%%%%%%%%%计算互信息%%%%%%%%%%%%
% 使用 entropy 函数计算信息熵
aaaa1 = imread('your own path\\IR\\IR.bmp');
aaaa2 = imread('your own path\\VI\\VI.bmp');
aaaa=imread('your own path\\waveletfusion4.bmp');
H1 = entropy(aaaa1);
H2 = entropy(aaaa2);
Hf = entropy(aaaa);
% 计算互信息
HU = H1 + H2 - Hf;
disp(['红外光信息熵' num2str(H1)]);
disp(['可见光信息熵' num2str(H2)]);
disp(['融合图信息熵' num2str(Hf)]);
disp(['互信息' num2str(HU)]);
%%%%%%%%%%%%%计算互信息%%%%%%%%%%%%