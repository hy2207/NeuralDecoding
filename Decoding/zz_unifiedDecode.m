%% 디코딩

Dfnc = Actv(:,actSingleList,:) - Base(:,actSingleList,:); % 관찰된 변화. 테스트 데이터로 쓰임.
% Dfnc = Actv(:,actMulti_List,:) - Base(:,actMulti_List,:);
%  muA_fake = bsxfun(@plus, muA_fake, [zeros(1,17), 100]');

h = waitbar(0,'Please wait...');
for idxLoop = 1:howmany
    
    tmp = randperm(NTotalNeurons);
    neuronList = tmp(1:usedNN(numel(usedNN)));
    recogResult = cell(numel(usedNN),1); % decoding with known set
    
    for idxTest = 1:Ntrials
        
        
        testD = permute( Dfnc(idxTest,:,neuronList) , [2 3 1]); % testD의 1차원은 동작임. 트라이얼 아님.
        
        %%-----------------------------------------------------------------
        switch flgReal
            
            case 1 % 실제 모델을 쓸 때, 트레이닝 데이터는 테스트 데이터가 바뀔때마다 만든다.
                
                trngTrial = setdiff(1:Ntrials,idxTest);
                trngA = permute( mean(Actv(trngTrial,actSingleList,neuronList) , 1) ,[2 3 1] ); % 일단 전체 선택
                trngB = permute( mean(Base(trngTrial,actSingleList,neuronList) , 1) ,[2 3 1]  );
                
%             case 2 % 대체모델을 쓸 때, 다중동작의 트레이닝 데이터는 테스트 트라이얼 넘버에 무관하므로 반복문 밖에서 미리 만들어도 되긴 한다.
%                 
%                 trngA = muA_fake(actMulti_List,neuronList);
%                 trngB = muB_fake(actMulti_List,neuronList);
        end
        %%-----------------------------------------------------------------
        
        %------------------------------------------------------------------
        probDensity = zeros(length(neuronList),NactS,NactS); % 뉴런별 후보별 확률밀도
        for idxNeuron = 1:length(neuronList),
            for idxCandi = 1:NactS,
                
                probDensity(idxNeuron,idxCandi,:) = z_skellam(...
                    testD( :, idxNeuron ),...
                    trngA( idxCandi , idxNeuron ),...
                    trngB( idxCandi , idxNeuron ));
            end
        end
        
        PprobDensity{idxTest} = probDensity; %%%%%%%%%%%%%
        PtestD{idxTest} = testD; %%%%%%%%%%%%%
        
        %------------------------------------------------------------------
        for idxStep = 1:length(usedNN),
            
            %--- 여기가 핵심 prob.의 log sum 구한다.  ----------------------
            tmpMat = permute( ...
                sum(...
                log( probDensity(1:usedNN(idxStep), :, : ) + verysmall )...
                , 1 )...
                , [2 3 1]); % probDensity의 행은 뉴런번호, 열은 후보동작번호, 층은 실행동작번호를 의미한다.
            % 트라이얼번호 인덱스는 없음.
            
            for idxMotion=1:NactS,
                [~,maxAddr] = max(tmpMat(:,idxMotion)); % 이게 맞다.
                
                switch maxAddr
                    case 1
                        z = 102;
                    case 2
                        z = 203;
                    case 3
                        z = 405;
                    case 4
                        z = 607;
                    case 5
                        z = 708;
                    case 6
                        z = 910;
                end
                
                recogResult{idxStep}(idxMotion,idxTest) = z;
                
            end
        end
        
    end
    
    
    
    %----------------------------------------------------------------------
    solutionList = [102 203 405 607 708 910];
    for idxStep = 1:numel(usedNN), % 채점
        
        R = zeros(NactS);
        for idx=1:NactS,
            R(:,idx) = mean( recogResult{idxStep} == solutionList(idx), 2 );
        end
        RR{idxStep}(:,:,idxLoop) = R;
    end
    %----------------------------------------------------------------------
    
    
    
    
    waitbar(idxLoop/howmany);
end
close(h);
clear idxR idxC R idxStep idxLoop idxTest R
