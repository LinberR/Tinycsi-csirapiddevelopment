function result=GetPhase(Txant,Rxant,Subc,RawCSI)
%��csi_entry�л�ȡcsi(rawcsi���Ѿ���read_bfee(bytes)��ȡ��Ľ����������Բο����ּ������е���ز���)
%csi_entry= csi_trace{i+startPkt};
csi = get_scaled_csi(RawCSI);
result=phase((csi(Txant,Rxant,Subc)));
end