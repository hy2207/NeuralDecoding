%% setting and data preprocessing

global K neuronNames actNames actNamesNeo p Ntrials rate Be On Nacts NTotalNeurons HIERC NttlCompnt

for nofunc=1
    
    NTotalNeurons = 115; % total num of neurons
    Nacts = 18; % tot of acting (single+multi finger mov)
    Ntrials = 6; % total num of trial
    
    p.fullStart  = 0.00e6; % usec. no firing rate before this time
    p.beforeStop = 0.50e6; % before 
    p.onsetStart = 0.60e6; % starting 'onset'
    p.onsetStop  = 1.50e6; % ending 'onset' 
    p.afterStart = 1.50e6; % staring 'after' point
    p.fullStop   = 1.81e6; % finish point. no firing rate after this time
    
    divWidth = 0.1e6; % firing rate width (usec.)
    maxTime = 2.5e6; % 발화량 산출 시 최대 시간
    paramAlpha = 5e4; % 발화량 산출 시 alpha 파라미터값. 5e4
    
    %     alpha_base = divWidth/(p.beforeStop - p.fullStart);
    %     alpha_actv = divWidth/(p.onsetStop - p.onsetStart);
    
    [~,t] = z_apprRate([], 'a', paramAlpha, 0, maxTime, []);
    Be = z_findnear(t, [p.fullStart p.beforeStop]);
    On = z_findnear(t, [p.onsetStart p.onsetStop]);
    
    actNames = {...
        'f1','f2','f3','f4','f5','fw','fCM1','fCM2','fCM3',...
        'e1','e2','e3','e4','e5','ew','eCM1','eCM2','eCM3',...
        'proj','projerr','CM'};
    
    actNamesNeoo = {...
        '1f', '2f', '3f', '4f', '5f', 'Wf','1+2f', '2+3f', '4+5f',...
        '1e', '2e', '3e', '4e', '5e', 'We','1+2e', '2+3e', '4+5e'};
    
    firing_ = -10:35; % 발화 차이 수 축. 충분히 지정해주는 게 좋다.
    load('K_64.mat'); % A01_merger; % 단일 및 다중 데이터 불러와서 병합하여 K_64.mat으로 저장한 결과 불러오기
end
%--------------------------------------------------------------------------
% 단순한 데이터 모으기. dat을 생성
%--------------------------------------------------------------------------
for nofunc=1,
    
    dat = cell(Ntrials,Nacts,NTotalNeurons);
    for idxNeuron = 1:NTotalNeurons,
        for idxMove = 1:Nacts,
            for idxTrial = 1:Ntrials,
                dat{idxTrial,idxMove,idxNeuron} = ...
                    K.(neuronNames{idxNeuron}).(actNames{idxMove}).(['trial',num2str(idxTrial)]);
            end
        end
    end
    clear idxNeuron idxMove idxTrial nofunc
    clear K
    
end
