function result=GetFreqUsingSTFT(csidata)
%��ʱ�����⣬�޷���������
T=length(csidata);
[tfr,t,f] = tfrstft(csidata',1:T,T,hamming(501),0); 
result=tfr;
end