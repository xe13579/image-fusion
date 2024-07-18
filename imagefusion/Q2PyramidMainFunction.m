%%%图像融合
%拉普拉斯金字塔最高层是高斯顶层
clc;
clear all;
close all;
imgaaa=double(imread('your own path\\imagefusion\\VI\\VI.bmp'));%可见光图读取
imgredaaa=double(imread('your own path\\imagefusion\\IR\\IR.bmp'));%红外图读取
[rows, cols, channels] = size(imgaaa);
p=4;%金字塔高度

Q1= LaplacianPyramid(imgaaa, p);%可见光图片拉普拉斯金字塔构建
Q2= LaplacianPyramid(imgredaaa, p);%红外光图片拉普拉斯金字塔构建

%构建融合金字塔%
blend_pyramid = cell(1,p);%设融合高斯金字塔有1,2,3,4层
blend_pyramidnengliang = cell(1,p);%设融合高斯金字塔有1,2,3,4层
for i = 1:p%构建融合图像的拉普拉斯金字塔
[a, b, c] = size(Q1{i});%获得可见光/红外光拉普拉斯金字塔的每层图像的尺寸
mute1{i} =double(ones(a, b, c)*0.5);%mute是用来将可见光和红外光相加的分别占比一半，用来调整亮度
mute2{i} =double(ones(a, b, c)*0.5);
blend_pyramid{i} = Q1{i} .*mute1{i} + Q2{i}.*mute2{i} ;%构建融合图像的拉普拉斯金字塔
blend_pyramidnengliang{i} = fenergyy(Q1{i},Q2{i});


end

%画图
% figure(1);
% subplot(3, 4, 1);imshow(uint8(Q2{1}));title('红外Laplace金字塔第一层');
% subplot(3, 4, 2);imshow(uint8(Q2{2}));title('红外Laplace金字塔第二层');
% subplot(3, 4, 3);imshow(uint8(Q2{3}));title('红外Laplace金字塔第三层');
% subplot(3, 4, 4);imshow(uint8(Q2{4}));title('红外Laplace金字塔第四层');
% subplot(3, 4, 5);imshow(uint8(Q1{1}));title('可见光Laplace金字塔第一层');
% subplot(3, 4, 6);imshow(uint8(Q1{2}));title('可见光Laplace金字塔第二层');
% subplot(3, 4, 7);imshow(uint8(Q1{3}));title('可见光Laplace金字塔第三层');
% subplot(3, 4, 8);imshow(uint8(Q1{4}));title('可见光Laplace金字塔第四层');
% subplot(3, 4, 9);imshow(uint8(blend_pyramid{1}));title('融合Laplace金字塔第一层');
% subplot(3, 4, 10);imshow(uint8(blend_pyramid{2}));title('融合Laplace金字塔第二层');
% subplot(3, 4, 11);imshow(uint8(blend_pyramid{3}));title('融合Laplace金字塔第三层');
% subplot(3, 4, 12);imshow(uint8(blend_pyramid{4}));title('融合Laplace金字塔第四层');

Q2blendImage = LaplacianReconstruct(blend_pyramid);%拉普拉斯金字塔重建，拉普拉斯金字塔会比高斯金字塔少一层
Q2blendImagenengliang = LaplacianReconstruct(blend_pyramidnengliang);
figure(3);
%class(Q2blendImage);double
% 显示图像
imshow(uint8(Q2blendImage));%输出最后融合的图像
title('融合图像');
figure(4);
imshow((Q2blendImagenengliang));%输出最后融合的图像，区域能量
title('区域能量算法融合图像');

imwrite(uint8(Q2blendImage), 'Pyramid.bmp');%保存
imwrite((Q2blendImagenengliang), 'Pyramid2.bmp');%保存，区域能量







%%%%%%%%%%峰值信噪比%%%%%%%%%
%PSNR 衡量的是：原始图像与融合图像中的实际信号之间的平均平方误差
%PSNR 的值越高，表示融合图像与原始图像之间的失真越小，图像质量越好
ir1 = imread('your own path\\imagefusion\\IR\\IR.bmp');
vi1 = imread('your own path\\imagefusion\\VI\\VI.bmp');
a=imread('your own path\\imagefusion\\Pyramid.bmp');
IR_psnr = psnr(ir1, a);
VI_psnr = psnr(vi1, a);
disp(['红外光与融合图峰值信噪比: ' num2str(IR_psnr)]);
disp(['可见光与融合图峰值信噪比: ' num2str(VI_psnr)]);
%%%%%%%%%%峰值信噪比%%%%%%%%%


%%%%%%%%%%%%交叉熵%%%%%%%%%%%%%%%%%%%%
% 导入图像
sourceImage1 = imread('your own path\\imagefusion\\IR\\IR.bmp');
sourceImage2 = imread('your own path\\imagefusion\\VI\\VI.bmp');
aa=imread('your own path\\imagefusion\\Pyramid.bmp');
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
aaa1 = imread('your own path\\imagefusion\\IR\\IR.bmp');
aaa2 = imread('your own path\\imagefusion\\VI\\VI.bmp');
aaa=imread('your own path\\imagefusion\\Pyramid.bmp');
SSIM1 = ssim(aaa1, aaa);
SSIM2 = ssim(aaa2, aaa);
disp(['红外光与融合图结构相似度: ' num2str(SSIM1)]);
disp(['可见光与融合图结构相似度: ' num2str(SSIM2)]);
%%%%%%%%%%%结构相似度%%%%%%%%%%


%%%%%%%%%%%%%计算互信息%%%%%%%%%%%%
% 使用 entropy 函数计算信息熵
aaaa1 = imread('your own path\\imagefusion\\IR\\IR.bmp');
aaaa2 = imread('your own path\\imagefusion\\VI\\VI.bmp');
aaaa=imread('your own path\\imagefusion\\Pyramid.bmp');
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