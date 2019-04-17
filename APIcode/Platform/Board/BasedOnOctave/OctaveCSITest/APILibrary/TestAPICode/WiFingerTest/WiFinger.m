function result=WiFinger(filename,trainortest,movementclass)
%����ʶ����Ҫ��KNN���࣬DWT�������
%LBJ 2018-9-19
%��Ҫ���̣�����CSI�ļ��������ȥ������ͨ�˲��������˸�Ƶ��������Mutlipathȥ������IFFT����ȡCIR��ɸȥdelay����100ns�ģ���FFT���CSI��
%          ���ƶ���ʶ��signindicator����ʲôʱ��ʼ�ж�������������Ƭ��KNN+DTW�������ѵ���������ࡣ
addpath('toolScripts');

csi_trace = read_bf_file(filename);
len = length(csi_trace);

%len=len-7900;%�ɼ�60s,Ƶ����100Hz������Ӧ����6000����������һ����13000�����������ICMP���صİ���--riot�²ɼ�������
len=len-8000;%�ɼ�60s,Ƶ����100Hz������Ӧ����6000����������һ����13000�����������ICMP���صİ���--palm�²ɼ�������
startPkt=1;
lastPkt=len;
ant=1;%���ն�����
CSI_measurements = zeros(30,len);

silent_time = 400;%��Ĭʱ�䣬����������ֵ��֮�������ƶ���ʱ�Ƚ�
window_size = 500;%�������Ƽ���ʱ�䴰��

if trainortest==1%ѵ��
count=1;
%��ȡ30�����ŵ������ֵ
for i = 1:lastPkt-startPkt
    csi_entry = csi_trace{i+startPkt};
    count=count+1;
%     count
%     len
%     i
%     csi_entry
    csi = get_scaled_csi(csi_entry);
    for sub=1:30
       CSI_measurements(sub,i) = db(abs(csi(1,ant,sub)));
       if isinf(CSI_measurements(sub,i))
            CSI_measurements(sub,i)=CSI_measurements(sub,i-1);
        end
    end
end
CSI_final_hampel = zeros(30,len);
butterworthResult= zeros(30,len);
multipathResult= zeros(30,len);
CSI_final= zeros(30,len);
movementProfile= zeros(1,len);
movementProfile_final= zeros(1,len);
% �����ȥ�� Outlier removal
for subc = 1:30
    %CSI_final_hampel(subc,:) = hampel(CSI_measurements(subc,:));
    CSI_final_hampel(subc,:)=medfilt1(CSI_measurements(subc,:),5);
end
figure;
plot(CSI_final_hampel(20,:));


%��ͨ�˲��� butterworth low passing fitter��ȥ��Ҳ������DWT��
fs=100; %����Ƶ�� sampling rate
fc=40;  %stopping frequency
order=4; 
[b,a]=butter(order,2*fc/fs);
for subc = 1:30
    butterworthResult(subc,:) = filter(b,a,CSI_final_hampel(subc,:));
end
% figure;
% plot(butterworthResult(20,:));


%�ྶЧӦȥ��Multipath Remove
% for subc = 1:30
%     temp(subc,:) = ifft(butterworthResult(subc,:));
%     for j=1:len
%         if temp(subc,j)<100
%             multipathResult(subc,j)=temp(subc,j);
%         else
%             multipathResult(subc,j)=0;
%         end
%     end
%     CSI_final(subc,:)=fft(multipathResult(subc,:));
% end
% figure;
% plot(CSI_final(20,:));
CSI_final= butterworthResult;

%���㾲Ĭʱ��ص�ֵ
for subc=1:30
   varSilent(subc) = var(CSI_final(subc,1:silent_time));%��׼��
 
end

count_profile=1;%����ͳ��profile�ĸ���
%�������Signindicator
for i=silent_time+1:len
    if mod(i, window_size) == 0
        windowCSI=CSI_final(:,i-window_size+1:i);
        %����signindicator
        arraytemp=windowCSI*windowCSI';%30*500��500*30������ˣ�����30*30�������������ֵ����������----��һ����̫��⣬��ʱ�����ˣ�ֱ���ñ�׼��仯�ϴ����ж�
        
        count_change=0;%ͳ��30�����ŵ��б�׼��仯��ĸ���
        for subc=1:30
           varNow(subc) = var( windowCSI(subc,:));%��׼��
           if(varNow(subc)>varSilent(subc))
               count_change=count_change+1;
           end
        end
        if count_change>1%ͳ�����ŵ�����16��ʱ����Ϊ�������ƶ���,��ʼ����profile
               movementProfile(i-window_size+1:i)=mean(windowCSI,1);
               fprintf('findone\n');
        end
        
    end
end
% figure;
% plot(movementProfile);

%DWT �����ϸ��ϵ�������΢С�仯����
[C,L]=wavedec(movementProfile,4,'db4');
d1 = wrcoef('d',C,L,'db4',1); 
d2 = wrcoef('d',C,L,'db4',2); 
d3 = wrcoef('d',C,L,'db4',3); 
d4 = wrcoef('d',C,L,'db4',4); 
movementProfile_final = d4;%ֻȡd4

% figure;
% plot(movementProfile_final);

%��ʼ����KNN+DTW���з��ࣨKNN�Ƿ��෽�������Ǿ��෽���������мලѧϰ������Ҫ��ǰָ��label��
%1.Train ѵ��
%��ʱ��Ϊ���ࣺȭͷ������
count_profile=1;
movementData= zeros(2,len);%��һ�ж����Ĳ���d4���ڶ������
j=1;
if trainortest==1 && movementclass==1%ѵ��ȭͷ
    for i=silent_time+1:len
        if mod(i, window_size) == 0

%             movementData(1,i-window_size+1:i)=d4(i-window_size+1:i);
%             movementData(2,i-window_size+1:i)=1;
            movementData(1,j:j+window_size-1)=d4(i-window_size+1:i);
            movementData(2,j:j+window_size-1)=1;
            j=j+window_size;
            count_profile=count_profile+1;
        end
    end
elseif trainortest==1 && movementclass==2%ѵ������
    for i=silent_time+1:len
        if mod(i, window_size) == 0
%             movementData(1,i-window_size+1:i)=d4(i-window_size+1:i);
%             movementData(2,i-window_size+1:i)=2;
            movementData(1,j:j+window_size-1)=d4(i-window_size+1:i);
            movementData(2,j:j+window_size-1)=2;
            j=j+window_size;
            count_profile=count_profile+1;
        end
    end
elseif trainortest==1 && movementclass==3%ѵ��book
    for i=silent_time+1:len
        if mod(i, window_size) == 0
%             movementData(1,i-window_size+1:i)=d4(i-window_size+1:i);
%             movementData(2,i-window_size+1:i)=1;
            movementData(1,j:j+window_size-1)=d4(i-window_size+1:i);
            movementData(2,j:j+window_size-1)=3;
            j=j+window_size;
            count_profile=count_profile+1;
        end
    end
end
%save('traindata_palm.mat','movementData');
save('testdata_book.mat','movementData');
% figure;
% plot(movementData(1,:));

%2.Test ���� Ҫ�õ�KNN��DTW��
elseif trainortest==2
%temp1=movementData(1,2001:2500);
%temp2=movementData(1,2051:2550);
% temp3=movementData(1,2051:2100);
% result1=GetDTWDist(temp1,temp2);
% result2=GetDTWDist(temp2,temp3);
% disp(result1);
% disp(result2);
traindata_riot=load('traindata_riot.mat');
traindata_palm=load('traindata_palm.mat');
traindata_book=load('traindata_book.mat');

testdata_palm=load('testdata_riot.mat');
testdata=testdata_palm.movementData(:,1:5000);
test_temp1=testdata(1,501:1000);

testdata_palm=load('testdata_palm.mat');
testdata=testdata_palm.movementData(:,1:5000);
test_temp2=testdata(1,501:1000);

testdata_palm=load('testdata_book.mat');
testdata=testdata_palm.movementData(:,1:5000);
test_temp3=testdata(1,501:1000);

movementData=[traindata_riot.movementData(:,1:5000) traindata_palm.movementData(:,1:5000) traindata_book.movementData(:,1:5000)];

profilesize=ceil(length(movementData)/500);
temp1=traindata_riot.movementData(1,501:1000);
temp2=traindata_palm.movementData(1,501:1000);
temp3=traindata_book.movementData(1,501:1000);

KNN(6,movementData,test_temp1,500,profilesize);
end


end