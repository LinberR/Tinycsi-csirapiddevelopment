function result=GetChangeSignIndicator(silentcsidata,csidata)
%�������Signindicator
silentCSI=silentcsidata;
windowCSI=csidata;
%����signindicator
arraytemp=windowCSI*windowCSI';%30*500��500*30������ˣ�����30*30�������������ֵ����������----��һ����̫��⣬��ʱ�����ˣ�ֱ���ñ�׼��仯�ϴ����ж�      
count_change=0;%ͳ��30�����ŵ��б�׼��仯��ĸ���
for subc=1:30
    varSilent(subc) = var( silentCSI(subc,:));%��׼��
    
end
for subc=1:30
    varNow(subc) = var( windowCSI(subc,:));%��׼��
    if(varNow(subc)>varSilent(subc))
               count_change=count_change+1;
    end
end
movementProfile=zeros(1,length(windowCSI));
if count_change>16%ͳ�����ŵ�����16��ʱ����Ϊ�������ƶ���,��ʼ����profile   
    fprintf('findone\n');
    movementProfile=mean(windowCSI,1);
end
result=movementProfile;
end