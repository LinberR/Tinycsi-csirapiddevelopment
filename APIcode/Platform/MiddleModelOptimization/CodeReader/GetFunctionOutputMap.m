function result=GetFunctionOutputMap(functionName)
csiFunctionName=char('GetAmplitude','GetPhase','GetRelativePhase','GetTimeStamp','GetRSSI','GetCFO','ButterworthFilter',...
                     'HampelFilter','MeadianFilter','PCAFilter','SelectSensitiveSubc',...
                      'GetVar','GetStd','GetMean','GetMAX','GetMIN','GetDTWDist','GetFreqVectorUsingDWT',...
                     'GetChangeSignIndicator','GetAoAUsingMUSIC','KNNClassifier');
%������������������ڴ���������С
%���㷽�������Ϊfloat��ռ4bytes��֮ǰʱ���ܺĵ����ݶ��ǻ���1000�����ݰ��⣬��˶���GetAmplitude�������Ϊ4000���������˲���Ҫ����ʱ�䴰������400
output=[4000 4000 4000 4000 2000 800 800 400 400 500 400 4000 4000 4000 4000 400 400 400 500 400 4000 4000];
for i=1:size(csiFunctionName,1)
      matches=0;
      matches=findstr(functionName,csiFunctionName(i,:));
     if length(matches)>0
        result=output(i);
        break;
    end
    end                
end