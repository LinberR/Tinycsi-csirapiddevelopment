function ret=KNN(K,traindata,testdata,windowsize,profilesize)
 %%���濪ʼKNN�㷨��
 %��������ݺ�����ÿ��profile���ݵ�DTW���� 
len=length(traindata);
count=1;
distance=zeros(2,profilesize);
len

for i=1:len
    if mod(i, windowsize) == 0
        distance(1,count)=GetDTWDist(traindata(1,i-windowsize+1:i),testdata);
        distance(2,count)=traindata(2,i-windowsize+1);
        count=count+1;
    end
end
% count
% distance
tmp=1;
label_ma=1;
%ѡ�����򷨣�ֻ�ҳ���С��ǰK������,�����ݺͱ�Ŷ���������
for i=1:K
   ma=distance(1,i);
   for j=i+1:count-1
     if distance(1,j)<ma
        ma=distance(1,j);
        label_ma=distance(2,j);
        tmp=j;
     end
   end
   distance(1,tmp)=distance(1,i);  %������
   distance(1,i)=ma;
   
   distance(2,tmp)=distance(2,i);        %�ű�ţ���Ҫʹ�ñ��
   distance(2,i)=label_ma;
end
% 
% distance
% %ð������
% for i=1:K
%     for j=1:count-1-i
%         if distance(1,j+1)<distance(1,j)
%             temp=distance(1,j);
%             distance(1,j)=distance(1,j+1);
%             distance(1,j+1)=temp;
%             temp_label=distance(2,j);
%             distance(2,j)=distance(2,j+1);
%             distance(2,j+1)=temp_label;
%         end
%     end
% end
distance

cls1=0; %ͳ����1�о��������������ĸ���
cls2=0;  %��2�о��������������ĸ���
cls3=0;

for i=1:K
   if distance(1,i)<1
      if distance(2,i)==1
         fprintf('����riot��\n'); 
      elseif distance(2,i)==2
         fprintf('����palm��\n'); 
      elseif distance(2,i)==3
         fprintf('����book��\n'); 
      end
      break;
   end    
   if distance(2,i)==1
     cls1=cls1+1;
   elseif distance(2,i)==2
     cls2=cls2+1;
   elseif distance(2,i)==3
     cls3=cls3+1;
   end
end
cls1
cls2
cls3
result=0;
if cls1>cls2 && cls1>cls3  
     fprintf('����riot��\n'); 
     result=1;
elseif cls2>cls1&&cls2>cls3
     fprintf('����palm��\n'); 
     result=2;
elseif cls3>cls1&&cls3>cls2
     fprintf('����book��\n'); 
     result=3;
end
ret=result;
end