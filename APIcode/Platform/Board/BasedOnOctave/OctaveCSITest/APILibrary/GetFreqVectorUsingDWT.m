function result=GetFreqVectorUsingDWT(csidata,n,wname,targetdetail)
%DWT �����ϸ��ϵ�������΢С�仯����
[C,L]=wavedec(csidata,n,wname);
d1 = wrcoef('d',C,L,'db4',1); 
d2 = wrcoef('d',C,L,'db4',2); 
d3 = wrcoef('d',C,L,'db4',3); 
d4 = wrcoef('d',C,L,'db4',4); 
if targetdetail==4
result = d4;%ֻȡd4
end