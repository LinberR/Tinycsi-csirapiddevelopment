function result=SelectSensitiveSubc(Txant,Rxant,RawCSI,silentEndPoint)
%ѡ����Ե�ǰ�����仯���е����ŵ�����
%csi_entry�ڴκ�������һ��csi_entry����һ��ʱ�䴰�ڵļ���
%SilentPktΪ��Ĭʱ��ε�csi_entry�ļ���
%silentRangeΪ��Ĭʱ���

count_channel=1;
length(RawCSI)
%����csi���ݻ�ȡ���ŵ�����
for num=1:length(RawCSI) 
  csiSubc_choose(:,num)=abs((RawCSI(Txant,Rxant,:)));
  for i_channel=1:30  
     stdSilent_choose_channel(i_channel)=std(csiSubc_choose(i_channel,1:silentEndPoint));
  end
            
  %fprintf('stdSilent_choose\n');
  %stdSilent_choose=mean(stdSilent_choose_channel)
    
  %fprintf('meanSilent_choose\n');
  %meanSilent_choose=mean(csiSubc_choose(:,1:silentEndPoint),2)
      
  for subc_test= 1:30
   csiSubc_choose(subc_test,1:silentEndPoint) = medfilt1(csiSubc_choose(subc_test,1:silentEndPoint),5);
  end
  for i = 1:stepLength
	selected_Channel=zeros(1,30);
    count_channel=1;
    for i_select=1:30
        if meanSilent_choose(i_select)-csiSubc_choose(i_select,bum-i+1) > stdSilent_choose_channel(i_select)
           selected_Channel(count_channel)=i_select;
           count_channel=count_channel+1;   
        end
    end
    fprintf('selected subc:\n');
    %selected_Channel(:)
    if count_channel>3
       sum_selected_channel=0;
       for i_count_channel=1:count_channel-1
          sum_selected_channel=sum_selected_channel+csiSubc_choose(selected_Channel(i_count_channel),num-i+1);
       end
    csiSubc_channel10log(num-i+1)=sum_selected_channel/(count_channel-1);
    else
       csiSubc_channel10log(num-i+1)=mean(abs((csi(Txant,Rxant,:))));
    end        
	end
end
result=selected_Channel(:);
end

