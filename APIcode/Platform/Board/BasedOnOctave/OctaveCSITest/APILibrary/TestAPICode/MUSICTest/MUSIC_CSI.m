function MUSIC_CSI(filename)
%��MUSIC�㷨����AOA��ToF������˼���������ز���չSensor�����ߣ��ĸ���
%��Ҫ�ο�Dymic-MUSIC���Լ�Spotfi
%Spotfi����15*2��DymicMUSIC��û˵
addpath('../toolScripts');

csi_trace = read_bf_file(filename);
len = length(csi_trace);

len=len-8000;%�ɼ�60s,Ƶ����100Hz������Ӧ����6000����������һ����13000�����������ICMP���صİ���--palm�²ɼ�������
len=500;
startPkt=1;
lastPkt=len;
window_size=50;
Degree_final_count=1;
CSI_measurements = zeros(90,len);
count=1;
%��ȡ30*3�����ŵ������ֵ
for i = 1:lastPkt-startPkt
    csi_entry = csi_trace{i+startPkt};
    csi = get_scaled_csi(csi_entry);
    count=count+1;
    for sub=1:30
       CSI_measurements_firstant(sub) =csi(1,1,sub);
       CSI_measurements_secondant(sub) =csi(1,2,sub);
       CSI_measurements_thirdant(sub) =csi(1,3,sub);
    end
    %���90��sensor
    %CSI_measurements=[CSI_measurements_firstant';CSI_measurements_secondant';CSI_measurements_thirdant'];
    CSI_measurements(1:30,i)=CSI_measurements_firstant';
    CSI_measurements(31:60,i)=CSI_measurements_secondant';
    CSI_measurements(61:90,i)=CSI_measurements_thirdant';
end

length(CSI_measurements)
pause;

%ʹ��MUSI�㷨���AOA
count=1;
ToA_count=1;
count_degree=1;
%ToA_all=zeros(361*window_size);
%SP_Array=zeros(window_size,361);%����ѡ��ǶȵĽ��
for i = 1:lastPkt-startPkt
    
       %MUSIC�㷨
       derad = pi/180;       
       radeg = 180/pi;
       twpi = 2*pi;
       kelm =  30*3;    %��Ԫ����     
       dd = 0.06;       %��Ԫ���       
       d=0:dd:(kelm-1)*dd;     
       iwave = 3;   
    
       Rxx=CSI_measurements(:,i)*CSI_measurements(:,i)';
       InvS=inv(Rxx); 
       [EV,D]=eig(Rxx);
       EVA=diag(D)';
       [EVA,I]=sort(EVA);
       EVA=fliplr(EVA);
       EV=fliplr(EV(:,I));
       for iang = 1:361
         angle(iang)=(iang-181)/2;
         phim=derad*angle(iang);
         a=exp(-j*twpi*d*sin(phim)).';
         %�Լ��ӵģ�ԭMUSIC�㷨��û�У���a��ǰ30������ΪToA
         ToA_all(ToA_count)=mean(a(1:30));
         ToA_count=ToA_count+1;
         %ToA_count
         %
         L=iwave;    
         En=EV(:,L+1:kelm);
         SP(iang)=(a'*a)/(a'*En*En'*a);
       end
       SP=abs(SP);
       SPmax=max(SP);
       SP=10*log10(SP/SPmax);%�������Ϊ��ѡ�ĽǶ�
       
%        if mod(i,500)==0
%        figure;
%        h=plot(angle,SP);
%        set(h,'Linewidth',2)
%        xlabel('angle (degree)')
%        ylabel('magnitude (dB)')
%        end
       
       SP_Array(count,:)=SP;
       
%        if count==1 
%            SP_Array(1,1:10)
%            pause;
%        end
       count=count+1;
       
     
       if mod(i,window_size)==0
           fprintf('im in\n')
           count_degree=1;
           count=1;
           ToA_count=1;
           for jj=1:361
               for ii=1:window_size
                   if SP_Array(ii,jj)>mean(SP_Array(:,jj))%����ƽ��ֵ��������ͼ������ͻ�����ģ�������Ϊ��ѡ�Ƕ�
                      
                       degreeselect(1,count_degree)=SP_Array(ii,jj);%��Ϊ��ѡ�ǶȾ��󣬵�һ��Ϊ�����ֵ�����������в���������ڶ���Ϊ�Ƕ�
                       degreeselect(2,count_degree)=jj;
                       degreeselect(3,count_degree)=ToA_all((jj-1)*50+ii);
                       count_degree=count_degree+1;
                   end
                   
               end
           end
%            i
%            length(SP_Array)
%            SP_Array(:,1)
           %degreeselect
           
           %staticpathȥ��
           table=tabulate(degreeselect(1,:));
           % length(table)
           [F,location]=max(table(:,2));
           location=find(table(:,2)==F);

           staticpath_Amp=table(location,1);%DymicMUSIC��֤��Staticpath������࣬ѡ������Ƶ�����ļ�Ϊstaticpath
           minToA=degreeselect(3,1);
           for iii=1:length(degreeselect)
               if degreeselect(1,iii)~=staticpath_Amp
                   %����TOA��ѡ��Targetpath��TargetPath��ToA��С
                   if degreeselect(3,iii)<minToA
                       minToA=degreeselect(3,iii);
                   %[minToA,location]=min(degreeselect(3,:));
                   end     
               end
         
           end 
           
          
          for iii=1:length(degreeselect)
                if degreeselect(3,iii)==minToA
                   Degree_final(Degree_final_count)=degreeselect(2,iii);
                   %degreeselect(2,iii)
                   Degree_final_count=Degree_final_count+1;
                end
          end
            
         
       end
      
end


Degree_final_result=mean(Degree_final);
Degree_final_result
    
%     figure;
%     h=plot(angle,SP);
%     set(h,'Linewidth',2)
%     xlabel('angle (degree)')
%     ylabel('magnitude (dB)')


end
