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
%����ˮӡ
picture =imread('tuxiang.jpg');
picture0 =picture;
subplot(2,5,1),imshow(picture),title('ԭʼ������ͼ��')
pic=picture(:,:,1);
subplot(2,5,2),imshow(pic),title('ԭʼ�������r')
secret = double(imread('shuiyin.bmp'));
subplot(2,5,3),imshow(secret),title('ԭʼ��ˮӡͼ��')
[p_x,p_y,p_z]=size(pic);
[s_x,s_y,s_z]=size(secret);
p_x8=floor(p_x/8);
p_y8=floor(p_y/8);
blockCell = cell(p_x8,p_y8);
ChangedMatrix = pic;
%��ͼ����зֿ�
for i=1:p_x8
   for j=1:p_y8
        blockCell{i,j}=pic(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8));
   end
end
%�Էֿ���ͼ�����DCT�任
for i=1:p_x8
   for j=1:p_y8
        blockCell{i,j}=dct2(blockCell{i,j});
   end
end
% ********************************************************************************
%��ˮӡͼ��Ƕ�뵽ԭʼͼ����
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
%ִ����ģã���任���������ĺ��ͼ�����ݴ洢������ChangedMatrix��
for i=1:p_x8
   for j=1:p_y8
         blockCell{i,j}=idct2(blockCell{i,j});
         ChangedMatrix(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8))=blockCell{i,j};
   end
end
subplot(2,5,4),imshow(ChangedMatrix),title('����ˮӡ�������r')
picture(:,:,1)=ChangedMatrix;
psnr(picture,picture0)
subplot(2,5,5),imshow(picture),title('����ˮӡ����')
imwrite (picture, 'result.bmp');

%******************************
%��ȡˮӡ
picture = imread('result.bmp');
subplot(2,5,6),imshow(picture),title('����ˮӡ��ͼ��')
[p_x,p_y,p_z]=size(picture);
p_x8=floor(p_x/8);
p_y8=floor(p_y/8);
BlockCell=cell(p_x8,p_y8);
ChangedMatrix = picture(:,:,1); 
subplot(2,5,7),imshow(ChangedMatrix),title('����ˮӡ�������r')
secret = double(imread('shuiyin.bmp'));
[s_x,s_y,s_z]=size(secret);
WMsize=[s_x,s_y];
WaterMatrix=zeros(WMsize);
% ���������㷨��QIM����ȡˮӡ�㷨
% ********************************************************************************
%��ͼ����зֿ飬ÿ��Ϊ8*8���ӿ�
for i=1:p_x8
   for j=1:p_y8
        BlockCell{i,j}=ChangedMatrix(((i-1)*8+1):(8*(i-1)+8),(8*(j-1)+1):(8*(j-1)+8));
   end
end
%�Էֿ���ͼ�����DCT�任
for i=1:p_x8
   for j=1:p_y8
        BlockCell{i,j}=dct2(BlockCell{i,j});
   end
end
% ********************************************************************************
%��ˮӡͼ��Ӹ��ĺ��ͼ������ȡ����
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
subplot (2,5,8),imshow (resultWM),title('ˮӡͼ��')
