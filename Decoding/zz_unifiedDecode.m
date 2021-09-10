%% Decoding

Dfnc = Actv(:,actSingleList,:) - Base(:,actSingleList,:); % test data
% Dfnc = Actv(:,actMulti_List,:) - Base(:,actMulti_List,:);
%  muA_fake = bsxfun(@plus, muA_fake, [zeros(1,17), 100]');

h = waitbar(0,'Please wait...');
for idxLoop = 1:howmany
    
    tmp = randperm(NTotalNeurons);
    neuronList = tmp(1:usedNN(numel(usedNN)));
    recogResult = cell(numel(usedNN),1); % decoding with known set
    
    for idxTest = 1:Ntrials
        
        
        testD = permute( Dfnc(idxTest,:,neuronList) , [2 3 1]); 
        
        %%-----------------------------------------------------------------
        switch flgReal
            
            case 1 % real model
                
                trngTrial = setdiff(1:Ntrials,idxTest);
                trngA = permute( mean(Actv(trngTrial,actSingleList,neuronList) , 1) ,[2 3 1] ); 
                trngB = permute( mean(Base(trngTrial,actSingleList,neuronList) , 1) ,[2 3 1]  );
                
%             case 2 % rebuild model
%                 
%                 trngA = muA_fake(actMulti_List,neuronList);
%                 trngB = muB_fake(actMulti_List,neuronList);
        end
        %%-----------------------------------------------------------------
        
        %------------------------------------------------------------------
        probDensity = zeros(length(neuronList),NactS,NactS); 
        for idxNeuron = 1:length(neuronList)
            for idxCandi = 1:NactS
                
                probDensity(idxNeuron,idxCandi,:) = z_skellam(...
                    testD( :, idxNeuron ),...
                    trngA( idxCandi , idxNeuron ),...
                    trngB( idxCandi , idxNeuron ));
            end
        end
        
        PprobDensity{idxTest} = probDensity; 
        PtestD{idxTest} = testD; 
        
        %------------------------------------------------------------------
        for idxStep = 1:length(usedNN)
            
            %--- calculate log sum ----------------------
            tmpMat = permute( ...
                sum(...
                log( probDensity(1:usedNN(idxStep), :, : ) + verysmall )...
                , 1 )...
                , [2 3 1]); % probDensity 
            
            for idxMotion=1:NactS,
                [~,maxAddr] = max(tmpMat(:,idxMotion)); 
                
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
    for idxStep = 1:numel(usedNN)
        
        R = zeros(NactS);
        for idx=1:NactS
            R(:,idx) = mean( recogResult{idxStep} == solutionList(idx), 2 );
        end
        RR{idxStep}(:,:,idxLoop) = R;
    end
    %----------------------------------------------------------------------
    
    
    
    
    waitbar(idxLoop/howmany);
end
close(h);
clear idxR idxC R idxStep idxLoop idxTest R
