%读取加入水印的图像
hide=imread('result.bmp');
%显示加入水印的图像
subplot (2,2,1),imshow (hide),title('加入水印图像')
%读取原始水印图像，并显示
secret2=imread('shuiyin.bmp');
subplot(2,2,2),imshow(secret2),title('原始水印图像')
%获取水印图像大小
[xx,yy,zz]=size(secret2);
%裁剪水印图像
hide = imnoise(hide,'salt & pepper',0.1);%添加噪声 
subplot(2,2,3),imshow(hide),title('添加噪声后')

%获取最低有效位
resulth=bitand(hide,1);
resulth=resulth(:,:,1);
%格式转换
resulth=logical(resulth);
resulth2=resulth(1:xx,1:yy,1);
%格式转换
resulth2=logical(resulth2);
%显示并保存最终水印
subplot(2,2,4),imshow(resulth2),title('提取大小水印图像')
imwrite(resulth2,'water2.bmp');
