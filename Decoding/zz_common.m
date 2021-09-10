
for nofunc=1
    
    NTotalNeurons = 115; % tot num of neurons
    Nacts = 18; % tot. num of mov
    Ntrials = 6; % tot. num of trial
    
    p = z_timeSet();
    
    actNames = {...
        'f1','f2','f3','f4','f5','fw','fCM1','fCM2','fCM3',...
        'e1','e2','e3','e4','e5','ew','eCM1','eCM2','eCM3',...
        'proj','projerr','CM'};
    
    actNamesNeoW = {...
        '1f', '2f', '3f', '4f', '5f', 'Wf','1+2f', '2+3f', '4+5f',...
        '1e', '2e', '3e', '4e', '5e', 'We','1+2e', '2+3e', '4+5e'};
    
    actSingleList = [1:5,10:14];
    actMulti_List = [7:9,16:18];
    actWrist_List = [6 15];
    
    load('K_64.mat');
end

%% collect data

for nofunc=1
    
    dat = cell(Ntrials,Nacts,NTotalNeurons);
    for idxNeuron = 1:NTotalNeurons
        for idxMove = 1:Nacts
            for idxTrial = 1:Ntrials
                dat{idxTrial,idxMove,idxNeuron} = ...
                    K.(neuronNames{idxNeuron}).(actNames{idxMove}).(['trial',num2str(idxTrial)]);
            end
        end
    end
    clear idxNeuron idxMove idxTrial nofunc actNames
    clear K
    
end

%% firing rate in base/ active
% each size is (6 x 18 x 115)
for nofunc=1
    
    %setting time
    Be = [p.fullStart p.beforeStop]; 
    On = [p.onsetStart p.onsetStop]; 
    
    timeDiv =  [Be On] % histogram bin
    clear Be On
    
    Base = zeros(Ntrials,Nacts,NTotalNeurons); % init
    Actv = zeros(Ntrials,Nacts,NTotalNeurons);
    
    for idxNeuron = 1:NTotalNeurons
        for idxMove = 1:Nacts
            for idxTrial = 1:Ntrials
                
                %                 tmp = histcounts( dat{idxTrial,idxMove,idxNeuron} , timeDiv); 
                
                tmp = ...
                    histc( dat{idxTrial,idxMove,idxNeuron} , timeDiv); %histogram count
                if ~isempty(tmp)
                    tmp(end)=[];
                end
                
                if  isempty(dat{idxTrial,idxMove,idxNeuron})
                    tmp = zeros(1,4);
                end
                
                Base(idxTrial,idxMove,idxNeuron) = tmp(1); %/ diff(Be); % firing rate in base
                Actv(idxTrial,idxMove,idxNeuron) = tmp(3); %/ diff(On); % firing rate in active
            end
        end
    end
    clear nofunc idxNeuron idxMove idxTrial tmp dat timeDiv  p
end