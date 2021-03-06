function IntrusionTest_oneChannelThreshold(handles,subc,SNThresRatio,silentDuration,windowLen)
global f;
global count;
global varSilent;
global csiSubc;

thehandles=handles;
broken_perm = 0;% Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6 9];

pauseTime = 0; % for real time purpose
subc = 15; % which subcarrier
SNThresRatio = 5; % the threshold of ratio between "nobody" environment and "intruder" environment
silentRange = [1,4]; % the time interval range we collect CSI in "nobody" environment as baseline
pingInterval = 0.05;
pingPktRate = 1;
windowDuration = 1; % window duration for judegement
stepDuration = 0.5; % 2 judegements for 1 second 
pktRate = 1 / pingInterval * pingPktRate; % the number of CSI matrixes in 1 second
silentPktRange = silentRange * pktRate; 
windowLength = windowDuration * pktRate;
stepLength = stepDuration * pktRate;
signalsome=[0 0];

%开始读取CSI文件中数据
field_len = fread(f,1,'uint16',0,'ieee-be');
    code = fread(f,1);
    if (code == 187)
        bytes = fread(f, field_len-1, 'uint8=>uint8');
        if(length(bytes) ~= field_len-1)
            % XXX
            fclose(f);
            return;
        end
    else %skip all other info
        fread(f,field_len-1);
        %continue;
    end

    if (code == 187)
        count = count + 1;
        ret{count} = read_bfee(bytes);
        perm = ret{count}.perm;
        Nrx = ret{count}.Nrx;

        if Nrx ~= 1 % No permuting needed for only 1 antenna
            if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
                if broken_perm == 0
                    broken_perm = 1;
                    fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', filename, Nrx, int2str(perm));
                end
            else
                ret{count}.csi(:,perm(1:Nrx),:) = ret{count}.csi(:,1:Nrx,:);
            end
        end
        
%         figure(1);
%         set(gcf,'position',[0 0.2 0.5 0.6],'Unit','normalized');
        csi = get_scaled_csi(ret{count});
        plot(thehandles.axes1,db(abs(squeeze(csi(1,1,:)).')),'LineWidth',2);
      
%         subplot(2,2,1);
%         plot(db(abs(squeeze(csi(1,1,:)).')),'LineWidth',2);
%         xlabel('CSI Subcarriers','fontsize',18);
%         ylabel('Amplitude','fontsize',18);
%         title('CSI RealTime Display');
        %set(h,'XData',t,'YData',m);
        axis([0,30,0,35]);
     
        csiSubc(count) = db(abs((csi(1,1,subc))));
        plot(thehandles.axes2,csiSubc,'LineWidth',2);
%          subplot(2,2,2);
%          plot(csiSubc,'LineWidth',2);
%         xlabel('Data Index','fontsize',18);
%         ylabel('Amplitude','fontsize',18);
%         title(strcat('One SubChannel:',num2str(subc)));
        axis([floor(count/500)*500,floor(count/500)*500+500,0,35]);
        drawnow;
        
%         subplot(2,2,3);
%         bar(signalsome,0.5);
%         %legend('No','Yes');
%         drawnow;
          
        if count == 1 
            fprintf('Receive the first CSI and wait for the baseline time...\n');
            %fflush(stdout);
            %continue;
        end

        if count == silentPktRange(1)
            fprintf('Enter into baseline time...\n');
            %fflush(stdout);
            %continue;
        end

        if count == silentPktRange(2)
            varSilent = var(csiSubc(silentPktRange(1):silentPktRange(2)));
            fprintf('Begin to detect...\n');
            fprintf('1 : An intruder, 0 : Safe\n');
            %fflush(stdout);
            %continue;
        end

        if count > silentPktRange(2) & mod(count - silentPktRange(2), stepLength) == 0
            if(SNThresRatio * varSilent < var(csiSubc(count - stepLength:count)))
                signalsome=[0 1];
				fprintf('1111\n');
                %fflush(stdout);
            else
                signalsome=[1 0];
                fprintf('0000\n');
                %fflush(stdout);
            end
            %continue;
        end
    end

end