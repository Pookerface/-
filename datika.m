data = imread("yang.jpg");  %答题卡
rg = imresize(data,0.5);
figure(1);
title("原图");
imshow(rg);          

% 
g1=rgb2gray(rg);
figure(2);
title("灰度图像");
imshow(g1);                    
% 
g1=adapthisteq(g1);     
figure(3);
title("增强对比度");
imshow(g1)
% 
g1 = imadjust(g1, [0 0.6], [0 1]);   %归一化
figure(4);
title("归一化");
imshow(g1);
% %原图像灰度范围为0-255，程序将小于0的灰度值设置为0，将大于255×0.6的灰度值设置为255
% 
g1 = ~im2bw(g1, graythresh(g1));     %图像二值化
figure(5);
title("反二值化图像");
imshow(g1);      

% %hough变换
figure(6);
imshow(g1);
hold on;
[H, T, R] = hough(g1);  %输入二值图像 返回 H-霍夫空间，T-theta角度，R-p半径
P = houghpeaks(H, 4, 'threshold', ceil(0.3*max(H(:))));  %输入霍夫空间和极值数量，返回极值的坐标
lines = houghlines(g1, T, R, P, 'FillGap', 50, 'MinLength', 7);
%FillGap是一个正实数，用来表示同一图像中两条线段的距离。当两条线的距离小于这个指定值时，
%houghlines函数就会将这两条线合并成一条线
%MinLength是一个正实数，用来确定是否保存线条。如果线条的长度小于这个值，线条将会被擦除，否则就保存。
%返回lines是一个包含图像中线段（首末点、半径和角度）4个元素的结构体）
%调用格式lines.point1 lines.point2 lines.theta lines.rho
max_len = 0;
for k = 1 : length(lines)
    xy = [lines(k).point1; lines(k).point2]; 
    len = norm(lines(k).point1-lines(k).point2); 
    Len(k) = len;
    if len > max_len
        max_len = len;
        y_long = xy;
    end
    XY{k} = xy; % 存储直线信息
end
[Len, ind] = sort(Len(:), 'descend'); % 按长度排序
% 直线信息排序
for i = 1 : length(ind)
    XYn{i} = XY{ind(i)};
end
xy_long = XYn{1};
x = xy_long(:, 1);
y = xy_long(:, 2);
if abs(diff(x)) < abs(diff(y))
    x = [mean(x); mean(x)];
else
    y = [0.7*y(1)+0.3*y(2); 0.3*y(1)+0.7*y(2)];
end
xy_long = [x y];
plot(xy_long(:,1), xy_long(:,2), 'LineWidth', 2, 'Color', 'r');
% 
zkz = g1;
da = g1;
mid = XYn{3};  %中间直线坐标
bot = XYn{4};  %底部直线坐标
if mid(1, 2) > bot(1, 2)
    t = mid;
    mid = bot;
    bot = t;
end
zkz(mid(1, 2) : 1 : bot(1, 2), :) = 0;
da(1 : mid(1, 2), :) = 0;
figure(7);
title("答案部分");
imshow(da);
 
%答题卡部分处理
p = round(0.01*numel(da)/70); 
da = bwareaopen(da,p); 
da(350:end,bot(1,1):bot(2,1)-20) = 0;
da(291:end,:) = 0;

% imshow(da);
% hold on;
[L1, num1] = bwlabel(da);%计算答题部分连通区域 按默认为8计算 区域内方框个数
stats1 = regionprops(L1);%给出每个方框的重心 
% 
Y = [];
for i=32:length(stats1)
    Y(i-31) = stats1(i).Centroid(2);
end    
xa1 = 28.5; xa2 = 127;xa3 =226;xa4 = 323;
A = [xa1,xa2,xa3,xa4];
xb1 = 45;xb2 = 143.5;xb3=241;xb4 = 340;
B=[xb1,xb2,xb3,xb4];
xc1 = 61; xc2 = 160;xc3 = 258;xc4 = 356;
C = [xc1,xc2,xc3,xc4];
xd1 = 77;xd2 = 175;xd3 = 373;
D = [xd1,xd2,xd3];
% 
figure(8);
title("答题卡答案识别");
imshow(rg,[]);
hold on;
%A
for i =1:length(A)
    for j = 1:length(stats1)
        if stats1(j).Centroid(1)<401
            if A(i) - 3 <stats1(j).Centroid(1) && stats1(j).Centroid(1) < A(i) + 3 
                for t = 1:length(Y)
                    if Y(t) - 3 < stats1(j).Centroid(2) && stats1(j).Centroid(2) < Y(t) +3 
                        text(A(i)+2,Y(t)+2,'A','color','b')
                    end
                end
            end
        end
    end
end

%B
for i =1:length(B)
    for j = 1:length(stats1)
        if stats1(j).Centroid(1)<401
            if B(i) - 1 <stats1(j).Centroid(1) && stats1(j).Centroid(1) < B(i) + 1 
                for t = 1:length(Y)
                    if Y(t) - 1 < stats1(j).Centroid(2) && stats1(j).Centroid(2) < Y(t) +1 
                        text(B(i)+2,Y(t)+2,'B','color','b')
                    end
                end
            end
        end
    end
end
%C
for i =1:length(C)
    for j = 1:length(stats1)
        if stats1(j).Centroid(1)<401
            if C(i) - 10 <stats1(j).Centroid(1) && stats1(j).Centroid(1) < C(i) + 10
                for t = 1:length(Y)
                    if Y(t) - 1 < stats1(j).Centroid(2) && stats1(j).Centroid(2) < Y(t) +1 
                        text(C(i)+2,Y(t)+2,'C','color','b')
                    end
                end
            end
        end
    end
end
%D
for i =1:length(D)
    for j = 1:length(stats1)
        if stats1(j).Centroid(1)<401
            if D(i) - 1 <stats1(j).Centroid(1) && stats1(j).Centroid(1) < D(i) + 1 
                for t = 1:length(Y)
                    if Y(t) - 1 < stats1(j).Centroid(2) && stats1(j).Centroid(2) < Y(t) +1 
                        text(D(i)+2,Y(t)+2,'D','color','b')
                    end
                end
            end
        end
    end
end            

% %准考证部分处理
figure(9);
% title("准考证部分");
% imshow(zkz);
p = round(0.01*numel(da)/70); 
da = bwareaopen(da,p); 
da(350:end,bot(1,1):bot(2,1)-20) = 0;
da(291:end,:) = 0;
p = round(0.01*numel(zkz)/125); 
zkz = bwareaopen(zkz,p); 
zkz(:,1:ceil(401/3)) = 0;
% imshow(zkz);
[L2, num2] = bwlabel(zkz);%计算答题部分连通区域 按默认为8计算 区域内方框个数
stats2 = regionprops(L2);%给出每个方框的重心
Y2 = [];
for i = 1:length(stats2)
    if stats2(i).Centroid(1) > 401
        Y2(length(stats2)-i+1) = stats2(i).Centroid(2);
    end
end
Y2 = sort(Y2);  
y2len = length(Y2)
zkz(1:Y2(1)-10,:) = 0;
zkz(Y2(y2len-2):end,:) = 0;
% imshow(zkz);
[L3, num3] = bwlabel(zkz);%计算答题部分连通区域 按默认为8计算 区域内方框个数
stats3 = regionprops(L3);%给出每个方框的重心
imshow(rg,[]);
hold on;
for i = 1:length(stats3)
    if stats3(i).Centroid(1)<401
        if Y2(1)-5<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(1)+5
                text(stats3(i).Centroid(1)+2,Y2(1),'0','color','b')
        end
        if Y2(2)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(2)+1
                text(stats3(i).Centroid(1)+2,Y2(2)+2,'1','color','b')
        end
        if Y2(3)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(3)+1
                text(stats3(i).Centroid(1)+2,Y2(3)+2,'2','color','b')    
        end
        if Y2(4)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(4)+1
                text(stats3(i).Centroid(1)+2,Y2(4)+2,'3','color','b')         
        end
        if Y2(5)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(5)+1
                text(stats3(i).Centroid(1)+2,Y2(5)+2,'4','color','b')
        end
        if Y2(6)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(6)+1
                text(stats3(i).Centroid(1)+2,Y2(6)+2,'5','color','b')
        end
        if Y2(7)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(7)+1
                text(stats3(i).Centroid(1)+2,Y2(7)+2,'6','color','b')   
        end
        if Y2(8)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(8)+1
                text(stats3(i).Centroid(1)+2,Y2(8)+2,'7','color','b')      
        end
        if Y2(9)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(9)+1
                text(stats3(i).Centroid(1)+2,Y2(8)+2,'8','color','b')
        end
        if Y2(10)-1<stats3(i).Centroid(2) && stats3(i).Centroid(2)< Y2(10)+1
                text(stats3(i).Centroid(1)+2,Y2(10)+2,'9','color','b')
        end            
    end
end



