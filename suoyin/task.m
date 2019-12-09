jpegStart = [16,11,10,16,24,40,50,61;
    12,12,14,19,26,58,60,55;
    14,13,16,24,40,57,69,56;
    14,17,22,29,51,87,80,62;
    18,22,37,56,68,109,103,77;
    24,35,55,64,91,104,113,92;
    49,64,78,87,103,121,120,101;
    72,92,95,98,112,100,103,99];
G = 0.5;%G
jpegD = round(jpegStart * G);
%插入水印
picture =imread('tuxiang.jpg');
picture0 =picture;
subplot(2,5,1),imshow(picture),title('原始的载体图像')
pic=picture(:,:,1);
subplot(2,5,2),imshow(pic),title('原始的载体的r')
secret = double(imread('shuiyin.bmp'));
subplot(2,5,3),imshow(secret),title('原始的水印图像')
[p_x,p_y,p_z]=size(pic);
[s_x,s_y,s_z]=size(secret);
p_x8=floor(p_x/8);
p_y8=floor(p_y/8);
blockCell = cell(p_x8,p_y8);
ChangedMatrix = pic;
%将图像进行分块
for i=1:p_x8
   for j=1:p_y8
        blockCell{i,j}=pic(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8));
   end
end
%对分块后的图像进行DCT变换
for i=1:p_x8
   for j=1:p_y8
        blockCell{i,j}=dct2(blockCell{i,j});
   end
end
% ********************************************************************************
%将水印图像嵌入到原始图像中
x = 1;
for i=1:s_x
    for j=1:s_y
        tempx = mod(x,64);
		x = mod(x+1,64);
        d0=jpegD(mod(round(tempx/8),8)+1,mod(tempx,8)+1)/4;               
        step =jpegD(mod(round(tempx/8),8)+1,mod(tempx,8)+1);
       d1=d0+step/2;
         if secret(i,j)==0
             blockCell{i,j}(4,4)=blockCell{i,j}(5,5)-(step*round((blockCell{i,j}(5,5)-blockCell{i,j}(4,4)+d0)/step)-d0);
         else
             blockCell{i,j}(4,4)=blockCell{i,j}(5,5)-(step*round((blockCell{i,j}(5,5)-blockCell{i,j}(4,4)+d1)/step)-d1);
         end
    end
end
%执行逆ＤＣＴ逆变换，并将更改后的图像数据存储到矩阵ChangedMatrix中
for i=1:p_x8
   for j=1:p_y8
         blockCell{i,j}=idct2(blockCell{i,j});
         ChangedMatrix(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8))=blockCell{i,j};
   end
end
subplot(2,5,4),imshow(ChangedMatrix),title('加入水印的载体的r')
picture(:,:,1)=ChangedMatrix;
psnr(picture,picture0)
subplot(2,5,5),imshow(picture),title('加入水印载体')
imwrite (picture, 'result.bmp');

%******************************
%提取水印
picture = imread('result.bmp');
subplot(2,5,6),imshow(picture),title('插入水印的图像')
[p_x,p_y,p_z]=size(picture);
p_x8=floor(p_x/8);
p_y8=floor(p_y/8);
BlockCell=cell(p_x8,p_y8);
ChangedMatrix = picture(:,:,1); 
subplot(2,5,7),imshow(ChangedMatrix),title('加入水印的载体的r')
secret = double(imread('shuiyin.bmp'));
[s_x,s_y,s_z]=size(secret);
WMsize=[s_x,s_y];
WaterMatrix=zeros(WMsize);
% 抖动调制算法，QIM的提取水印算法
% ********************************************************************************
%将图像进行分块，每块为8*8的子块
for i=1:p_x8
   for j=1:p_y8
        BlockCell{i,j}=ChangedMatrix(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8));
   end
end
%对分块后的图像进行DCT变换
for i=1:p_x8
   for j=1:p_y8
        BlockCell{i,j}=dct2(BlockCell{i,j});
   end
end
% ********************************************************************************
%将水印图像从更改后的图像中提取出来
thisx=1;
for i=1:s_x
    for j=1:s_y
		tempx = mod(thisx,64);
		thisx = mod(thisx+1,64);
        d0=jpegD(mod(round(tempx/8),8)+1,mod(tempx,8)+1)/4;                   
        step =jpegD(mod(round(tempx/8),8)+1,mod(tempx,8)+1);
        d1=d0+step/2;
         x=(BlockCell{i,j}(5,5)-BlockCell{i,j}(4,4))-(step*round((BlockCell{i,j}(5,5)-BlockCell{i,j}(4,4)+d0)/step)-d0);
         y=(BlockCell{i,j}(5,5)-BlockCell{i,j}(4,4))-(step*round((BlockCell{i,j}(5,5)-BlockCell{i,j}(4,4)+d1)/step)-d1);
         if abs(x)<abs(y)
             WaterMatrix(i,j)=0;
         else
             WaterMatrix(i,j)=1;
         end
    end
end
resultWM = logical(WaterMatrix);
subplot (2,5,8),imshow (resultWM),title('水印图像')
