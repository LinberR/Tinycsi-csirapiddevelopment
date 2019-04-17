function SecretKeyExtraction(Alicefilename,Bobfilename)
Alice_csi_trace = read_bf_file(Alicefilename);
Bob_csi_trace = read_bf_file(Bobfilename);
Alice_len = length(Alice_csi_trace);
Bob_len = length(Bob_csi_trace);
count=1;
for j = 1:Alice_len
    csi_entry = Alice_csi_trace{j};
    csi = get_scaled_csi(csi_entry);
    %�����ֵ
    Alice_Amplitude(count,:) = db(abs((csi(1,1,:))));
    count=count+1;
end

count=1;
for j = 1:Bob_len
    csi_entry = Bob_csi_trace{j};
    csi = get_scaled_csi(csi_entry);
    %�����ֵ
    Bob_Amplitude(count,:) = db(abs((csi(1,1,:))));
    count=count+1;
end
%�����ȵ���(probe packet)�ĸ����ﵽ200���Ժ󣬿��Կ������뻥�����ȶ�ʱ��
for j=200:Alice_len
   %�������油������complement�����������������豸�˵����ʹ���������
   for i=1:30
       temp(j,i)=Alice_Amplitude(j,i)-Bob_Amplitude(j,i);
   end
end
%���30*M�����ÿ�е�ƽ��ֵ����ÿ�����ز���ƽ��ֵ����Ϊ������
uf=mean(temp,2);
%����Alice���в���
for j=200:Alice_len
   %�������油������complement�����������������豸�˵����ʹ���������
   for i=1:30
       Alice_Result(j,i)=Alice_Amplitude(j,i)-uf(i);
   end
end
%���ڽ������Alice_Result��������(Quantization)�ͱ���(Encode)
%������̫����û����ֱ�����ı���
Threshold=30;%��ֵ�Լ��趨�ģ�Ҳ����ȡƽ��ֵ֮���
SecretKeyLencount=1
for j=200:Alice_len
   %�������油������complement�����������������豸�˵����ʹ���������
   for i=1:30
       %�����������������Thresholdʱ����Ϊ1������Ϊ0
       if Alice_Result(j,i)>Threshold
           Alice_SecretKey(SecretKeyLencount)=1;
       else 
           Alice_SecretKey(SecretKeyLencount)=0;
       end
       SecretKeyLencount=SecretKeyLencount+1;
   end
end
end
