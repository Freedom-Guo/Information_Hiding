%��ȡ����ˮӡ��ͼ��
hide=imread('result.bmp');
%��ʾ����ˮӡ��ͼ��
subplot (2,2,1),imshow (hide),title('����ˮӡͼ��')
%��ȡԭʼˮӡͼ�񣬲���ʾ
secret2=imread('shuiyin.bmp');
subplot(2,2,2),imshow(secret2),title('ԭʼˮӡͼ��')
%��ȡˮӡͼ���С
[xx,yy,zz]=size(secret2);
%�ü�ˮӡͼ��
hide = imnoise(hide,'salt & pepper',0.1);%������� 
subplot(2,2,3),imshow(hide),title('���������')

%��ȡ�����Чλ
resulth=bitand(hide,1);
resulth=resulth(:,:,1);
%��ʽת��
resulth=logical(resulth);
resulth2=resulth(1:xx,1:yy,1);
%��ʽת��
resulth2=logical(resulth2);
%��ʾ����������ˮӡ
subplot(2,2,4),imshow(resulth2),title('��ȡ��Сˮӡͼ��')
imwrite(resulth2,'water2.bmp');
