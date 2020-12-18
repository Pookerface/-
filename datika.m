data = imread("yang.jpg");  %���⿨
rg = imresize(data,0.5);
figure(1);
title("ԭͼ");
imshow(rg);          

% 
g1=rgb2gray(rg);
figure(2);
title("�Ҷ�ͼ��");
imshow(g1);                    
% 
g1=adapthisteq(g1);     
figure(3);
title("��ǿ�Աȶ�");
imshow(g1)
% 
g1 = imadjust(g1, [0 0.6], [0 1]);   %��һ��
figure(4);
title("��һ��");
imshow(g1);
% %ԭͼ��Ҷȷ�ΧΪ0-255������С��0�ĻҶ�ֵ����Ϊ0��������255��0.6�ĻҶ�ֵ����Ϊ255
% 
g1 = ~im2bw(g1, graythresh(g1));     %ͼ���ֵ��
figure(5);
title("����ֵ��ͼ��");
imshow(g1);      

% %hough�任
figure(6);
imshow(g1);
hold on;
[H, T, R] = hough(g1);  %�����ֵͼ�� ���� H-����ռ䣬T-theta�Ƕȣ�R-p�뾶
P = houghpeaks(H, 4, 'threshold', ceil(0.3*max(H(:))));  %�������ռ�ͼ�ֵ���������ؼ�ֵ������
lines = houghlines(g1, T, R, P, 'FillGap', 50, 'MinLength', 7);
%FillGap��һ����ʵ����������ʾͬһͼ���������߶εľ��롣�������ߵľ���С�����ָ��ֵʱ��
%houghlines�����ͻὫ�������ߺϲ���һ����
%MinLength��һ����ʵ��������ȷ���Ƿ񱣴���������������ĳ���С�����ֵ���������ᱻ����������ͱ��档
%����lines��һ������ͼ�����߶Σ���ĩ�㡢�뾶�ͽǶȣ�4��Ԫ�صĽṹ�壩
%���ø�ʽlines.point1 lines.point2 lines.theta lines.rho
max_len = 0;
for k = 1 : length(lines)
    xy = [lines(k).point1; lines(k).point2]; 
    len = norm(lines(k).point1-lines(k).point2); 
    Len(k) = len;
    if len > max_len
        max_len = len;
        y_long = xy;
    end
    XY{k} = xy; % �洢ֱ����Ϣ
end
[Len, ind] = sort(Len(:), 'descend'); % ����������
% ֱ����Ϣ����
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
mid = XYn{3};  %�м�ֱ������
bot = XYn{4};  %�ײ�ֱ������
if mid(1, 2) > bot(1, 2)
    t = mid;
    mid = bot;
    bot = t;
end
zkz(mid(1, 2) : 1 : bot(1, 2), :) = 0;
da(1 : mid(1, 2), :) = 0;
figure(7);
title("�𰸲���");
imshow(da);
 
%���⿨���ִ���
p = round(0.01*numel(da)/70); 
da = bwareaopen(da,p); 
da(350:end,bot(1,1):bot(2,1)-20) = 0;
da(291:end,:) = 0;

% imshow(da);
% hold on;
[L1, num1] = bwlabel(da);%������ⲿ����ͨ���� ��Ĭ��Ϊ8���� �����ڷ������
stats1 = regionprops(L1);%����ÿ����������� 
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
title("���⿨��ʶ��");
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

% %׼��֤���ִ���
figure(9);
% title("׼��֤����");
% imshow(zkz);
p = round(0.01*numel(da)/70); 
da = bwareaopen(da,p); 
da(350:end,bot(1,1):bot(2,1)-20) = 0;
da(291:end,:) = 0;
p = round(0.01*numel(zkz)/125); 
zkz = bwareaopen(zkz,p); 
zkz(:,1:ceil(401/3)) = 0;
% imshow(zkz);
[L2, num2] = bwlabel(zkz);%������ⲿ����ͨ���� ��Ĭ��Ϊ8���� �����ڷ������
stats2 = regionprops(L2);%����ÿ�����������
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
[L3, num3] = bwlabel(zkz);%������ⲿ����ͨ���� ��Ĭ��Ϊ8���� �����ڷ������
stats3 = regionprops(L3);%����ÿ�����������
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



