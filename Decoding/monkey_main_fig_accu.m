clear all; clc;
close all;

zz_common; % 공통부분 스크립트. 원본데이터를 읽어와서 목적에 맞게 정리한다.

%%
for flgReal = 1:1  % 1이면 real, 2면 fake(rebuild)
    
    verysmall = 1e-5;
    howmany = 50; %input('반복횟수를 입력해야겠쥬? : ');
    
    NactS = numel(actSingleList);
    NactM = numel(actMulti_List);
    usedNN = unique([1:10 15:5:40]); % 반드시 오름차순이어야 한다.
    RR = cell(numel(usedNN),1);
    
    switch flgReal
        case 1
            fileNamet = 'accuConven';
        case 2
            zz_rebuild; % 재조합(대체 모델 생성) 스크립트
            fileNamet = 'accuRebuit';
    end
    zz_unifiedDecode; % 통합 디코더
    
    %------------------------------- 사용한 뉴런 개수 별 정확도 평균 및 편차
    meanAccu = zeros(numel(usedNN),size(RR{1},1));
    stdAccu =  zeros(numel(usedNN),size(RR{1},1));
    for idx=1:numel(usedNN),
        meanAccu(idx,:) = diag(mean(RR{idx},3))*100;
        stdAccu(idx,:) = diag(std(RR{idx},[],3))*100;
    end
    
    %----------------------------------------------------- 성능 결산 그래프
    for nofunc=1
        
%         m = {'o-','d-','^-','*-','x-','s-','p-','v-','>-','<-','p-','h-'};
%         set_marker_order = @() set(gca(), ...
%             'LineStyleOrder',m, 'ColorOrder',[0 0 0], ...
%             'NextPlot','replacechildren');
%         
%         z_canvas(6,4);
%         z_sub(1,1,1,[0 0 -.25 0 0 0]);
%         set_marker_order();
%         %         plot([0, usedNN],[zeros(6,1), meanAccu'],'linewidth',1);
%         errorbar(repmat([0 usedNN]',1,6),[zeros(1,6); meanAccu],[zeros(1,6); stdAccu],'linewidth',1,'MarkerFaceColor','w');
%         grid on; box on;
%         xlim([-1 usedNN(end)+1]);
%         ylim([0 105]);
%         xlabel('Number of neurons','fontsize',11);
%         ylabel('Decoding accuracy [%]','fontsize',11);
%         legend(actNamesNeoW(actMulti_List),...
%             'Orientation','vertical',...
%             'Location','southeast',...
%             'FontSize',11);
%         set(gca,'xtick',[get(gca,'xtick'), NTotalNeurons]);
%         z_pdf(fileNamet,1);
%         saveas(gcf,[fileNamet,'.fig']);
%         save(fileNamet)
        
        % ------------------------------판별정확도의 동작 평균과 편차 그래프
        z_canvas(6,4);
        z_sub(1,1,1,[0 0 0 0 0 0]);
        errorbar([0 usedNN],[0; mean(meanAccu,2)], [0; std(meanAccu,[],2)],'v-k',...
            'MarkerFaceColor','w');
        xlabel('Number of neurons','fontsize',11);
        ylabel('Decoding accuracy [%]','fontsize',11);
        grid on;
        ylim([0 105]);
        xlim([-1 usedNN(end)+1]);
        legend({'Non-blind decoding','Semi-blind decoding'},'location','southeast');
        title('Monkey K (6 combind two-finger movements)','fontsize',11);
%         title('Monkey S (2 combind two-finger movements)','fontsize',11);
%         fileNamet = 'monkeyS';
%         z_pdf(fileNamet,1);
%         saveas(gcf,[fileNamet,'.fig']);

        
        %------------------------------------- confusion matrix들
        usedNeuronsAddr = find(usedNN == 5);
        z_canvas(4,4);
        z_sub(1,1,1,[0 0 -.25 0 0 0]);
        z_matImage(mean(RR{usedNeuronsAddr},3),[0 1],[],(mean(RR{usedNeuronsAddr},3)),actNamesNeoW([7:9 16:18]));
        fontsizeLbl = 11;
        xlabel('Inferred motion','fontsize',fontsizeLbl);
        ylabel('Actual motion','fontsize',fontsizeLbl);
        title([num2str(usedNN(usedNeuronsAddr)),' neurons were used for decoding'],'fontsize',fontsizeLbl);
        fileNamet = [fileNamet,'_deco20'];
        %     z_pdf(fileNamet,1);
        
        z_canvas(4,4);
        z_sub(1,1,1,[0 0 -.25 0 0 0]);
        z_matImage(mean(RR{end},3),[0 1],[],(mean(RR{end},3)),actNamesNeoW([7:9 16:18]));
        fontsizeLbl = 11;
        xlabel('Inferred motion','fontsize',fontsizeLbl);
        ylabel('Actual motion','fontsize',fontsizeLbl);
        title([num2str(usedNN(end)),' neurons were used for decoding'],'fontsize',fontsizeLbl);
        fileNamet = [fileNamet,'_deco80'];
        %     z_pdf(fileNamet,1);
        
    end
    
end
