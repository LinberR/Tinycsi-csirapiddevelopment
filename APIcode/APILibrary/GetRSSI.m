function result=GetRSSI(csi_entry)
%��csientry�л�ȡ���Ͷ�ÿ�����ߵ�Rssi
temp_result(1)=csi_entry.rssi_a;
temp_result(2)=csi_entry.rssi_b;
temp_result(3)=csi_entry.rssi_c;
result=mean(temp_result);

end