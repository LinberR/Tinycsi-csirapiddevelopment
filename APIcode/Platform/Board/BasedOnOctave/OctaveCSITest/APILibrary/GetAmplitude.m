function result=GetAmplitude(Txant,Rxant,Subc,RawCSI)
%��csi_entry�л�ȡcsi(rawcsi���Ѿ���read_bfee(bytes)��ȡ��Ľ����������Բο����ּ������е���ز���)
%csi_entry= csi_trace{i+startPkt};
csi = get_scaled_csi(RawCSI);
result=db(abs(squeeze(csi(Txant,Rxant,Subc))));
end