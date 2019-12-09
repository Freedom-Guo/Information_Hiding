%读取原始图像
carner=imread('tuxiang.bmp');
%显示原始图像
subplot(3,3,1),imshow(carner),title('原始载体图像')
%最低位置为0
carner1=bitand(carner,254);
%读取水印图像
secret=imread('shuiyin.bmp');
%显示水印图像
subplot(3,3,2),imshow(secret),title('原始水印图像')
%水印图像格式转换
secret=uint8(secret);
%获取水印图像大小
[x,y,z]=size(secret);
%水印图像与载体图像整合
result=carner1;
result(1:x,1:y,1:z)=result(1:x,1:y,1:z)+secret;
%计算并打印PSNR值
psnr(result,carner)
%显示加入水印的图像
subplot (3,3,3),imshow (result),title('隐藏后的载体图像')
%保存结果
imwrite (result, 'result.bmp');

%读取加入水印的图像
hide=imread('result.bmp');
%显示加入水印的图像
subplot (3,3,4),imshow (hide),title('加入水印图像')
%获取最低有效位
resulth=bitand(hide,1);
resulth=resulth(:,:,1);
%格式转换
resulth=logical(resulth);
%显示并保存图像
subplot (3,3,5),imshow (resulth),title('水印图像')
imwrite(resulth,'water.bmp');
%读取原始水印图像，并显示
secret2=imread('shuiyin.bmp');
subplot(3,3,6),imshow(secret2),title('原始水印图像')
%获取水印图像大小
[xx,yy,zz]=size(secret2);
%裁剪水印图像
resulth2=resulth(1:xx,1:yy,1);
%格式转换
resulth2=logical(resulth2);
%显示并保存最终水印
subplot(3,3,7),imshow(resulth2),title('提取大小水印图像')
imwrite(resulth2,'water1.bmp');

