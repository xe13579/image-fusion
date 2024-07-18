function new=fenergyy(a,b)


% 分解为 RGB 三个通道
R1 = a(:,:,1);
G1 = a(:,:,2);
B1 = a(:,:,3);

R2 = b(:,:,1);
G2 = b(:,:,2);
B2 = b(:,:,3);
%nlfilter 函数会遍历图像的每个像素，并将该像素及其周围 m x n 个像素组成一个矩阵，
% 作为 nengliang 函数的输入。fun 函数会处理这个矩阵，并返回一个新的值，
% 作为该像素的输出。
% 计算每个通道的区域能量
temp_ar = nlfilter(R1,[3 3],@nengliang);
temp_br = nlfilter(R2,[3 3],@nengliang);
temp_ag = nlfilter(G1,[3 3],@nengliang);
temp_bg = nlfilter(G2,[3 3],@nengliang);
temp_ab = nlfilter(B1,[3 3],@nengliang);
temp_bb = nlfilter(B2,[3 3],@nengliang);

% 根据能量大小进行融合
[mr,nr] = size(R1);
[mg,ng] = size(G1);
[mb,nb] = size(B1);

newr = zeros(mr,nr);
newg = zeros(mg,ng);
newb = zeros(mb,nb);

for i=1:mr
    for j=1:nr
        if temp_ar(i,j)>=temp_br(i,j)
            newr(i,j)=R1(i,j);
        else
            newr(i,j)=R2(i,j);
        end
    end
end

for i=1:mg
    for j=1:ng
        if temp_ag(i,j)>=temp_bg(i,j)
            newg(i,j)=G1(i,j);
        else
            newg(i,j)=G2(i,j);
        end
    end
end

for i=1:mb
    for j=1:nb
        if temp_ab(i,j)>=temp_bb(i,j)
            newb(i,j)=B1(i,j);
        else
            newb(i,j)=B2(i,j);
        end
    end
end

 newr = newr/255;
 newg = newg/255;
 newb = newb/255;
% 合并通道
new = cat(3, newr, newg, newb);

end

function c=nengliang(x)                 %权值函数
A=[2 4 2; 4 8 4; 2 4 2];                              %权值矩阵
C=A.*x;  % 计算每个像素的权重能量
c=sum(sum(C));  % 求和得到区域能量
end