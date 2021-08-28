
for nofunc=1
    
    NTotalNeurons = 115; % 총 뉴런 수
    Nacts = 18; % 총 (단일+다중) 손가락동작 개수
    Ntrials = 6; % 총 트라이얼 개수. 사실 이것보다 많은 뉴런도 있는데..(동시 레코딩이 아니라서)
    
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
    
%     load('..\K_64.mat'); % A01_merger; % 단일 및 다중 데이터 불러와서 병합하여 K_64.mat으로 저장한 결과 불러오기
    load('K_64.mat');
end

%% 단순한 데이터 모으기. dat을 생성
% dat 이라는 다차원 행렬 생성
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

%% base구간과 active구간의 발화율 각각 추출
% 각 사이즈는 6 x 18 x 115 가 된다.
for nofunc=1
    
    Be = [p.fullStart p.beforeStop]; % 시간 구간 설정
    On = [p.onsetStart p.onsetStop]; % 시간 구간 설정
    
    timeDiv =  [Be On] % 히스토그램의 빈이 된다.
    clear Be On
    
    Base = zeros(Ntrials,Nacts,NTotalNeurons); % 초기화
    Actv = zeros(Ntrials,Nacts,NTotalNeurons);
    
    for idxNeuron = 1:NTotalNeurons
        for idxMove = 1:Nacts
            for idxTrial = 1:Ntrials
                
                %                 tmp = histcounts( dat{idxTrial,idxMove,idxNeuron} , timeDiv); %히스토그램카운트
                
                tmp = ...
                    histc( dat{idxTrial,idxMove,idxNeuron} , timeDiv); %히스토그램카운트
                if ~isempty(tmp)
                    tmp(end)=[];
                end
                
                if  isempty(dat{idxTrial,idxMove,idxNeuron})
                    tmp = zeros(1,4);
                end
                
                Base(idxTrial,idxMove,idxNeuron) = tmp(1); %/ diff(Be); % BASE 구간 내 발화개수
                Actv(idxTrial,idxMove,idxNeuron) = tmp(3); %/ diff(On); % ACTIVE 구간 내 발화개수
            end
        end
    end
    clear nofunc idxNeuron idxMove idxTrial tmp dat timeDiv  p
end