%��ȡԭʼͼ��
carner=imread('tuxiang.bmp');
%��ʾԭʼͼ��
subplot(3,3,1),imshow(carner),title('ԭʼ����ͼ��')
%���λ��Ϊ0
carner1=bitand(carner,254);
%��ȡˮӡͼ��
secret=imread('shuiyin.bmp');
%��ʾˮӡͼ��
subplot(3,3,2),imshow(secret),title('ԭʼˮӡͼ��')
%ˮӡͼ���ʽת��
secret=uint8(secret);
%��ȡˮӡͼ���С
[x,y,z]=size(secret);
%ˮӡͼ��������ͼ������
result=carner1;
result(1:x,1:y,1:z)=result(1:x,1:y,1:z)+secret;
%���㲢��ӡPSNRֵ
psnr(result,carner)
%��ʾ����ˮӡ��ͼ��
subplot (3,3,3),imshow (result),title('���غ������ͼ��')
%������
imwrite (result, 'result.bmp');

%��ȡ����ˮӡ��ͼ��
hide=imread('result.bmp');
%��ʾ����ˮӡ��ͼ��
subplot (3,3,4),imshow (hide),title('����ˮӡͼ��')
%��ȡ�����Чλ
resulth=bitand(hide,1);
resulth=resulth(:,:,1);
%��ʽת��
resulth=logical(resulth);
%��ʾ������ͼ��
subplot (3,3,5),imshow (resulth),title('ˮӡͼ��')
imwrite(resulth,'water.bmp');
%��ȡԭʼˮӡͼ�񣬲���ʾ
secret2=imread('shuiyin.bmp');
subplot(3,3,6),imshow(secret2),title('ԭʼˮӡͼ��')
%��ȡˮӡͼ���С
[xx,yy,zz]=size(secret2);
%�ü�ˮӡͼ��
resulth2=resulth(1:xx,1:yy,1);
%��ʽת��
resulth2=logical(resulth2);
%��ʾ����������ˮӡ
subplot(3,3,7),imshow(resulth2),title('��ȡ��Сˮӡͼ��')
imwrite(resulth2,'water1.bmp');

