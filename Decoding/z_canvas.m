function [hFig] = z_canvas(w_, h_, barHideOpt, rendererTypeN )

if nargin <3 || isempty(barHideOpt),
    barHideOpt = [false false];
end

if nargin <4 || isempty(rendererTypeN),
    rendererTypeN = 1;
end

switch rendererTypeN
    case 1
        rendererType = 'painters';
    case 2
        rendererType = 'OpenGL';
    case 3
        rendererType = 'zbuffer';
end


global fig_width fig_height
fig_width = w_;
fig_height = h_;
set(0,'Units','inches');
scrsz = get(0,'ScreenSize');

% fontname1 = 'times new roman';
fontname2 = 'Arial';
set(0,'defaultaxesfontname',fontname2);
set(0,'defaulttextfontname',fontname2);
fontsize = 9; % pt
set(0,'defaultaxesfontsize',fontsize);
set(0,'defaulttextfontsize',fontsize);
set(0,'fixedwidthfontname',fontname2);

hFig = figure;
if barHideOpt(1),
    set(hFig, 'MenuBar', 'none');
end
if barHideOpt(2),
    set(hFig, 'ToolBar', 'none');
end

set(hFig,'renderer',rendererType);% OpenGL zbuffer painters
set(hFig,'units','inches');
set(hFig,'position',[(scrsz(3)-fig_width)/2, (scrsz(4)-fig_height)/2, fig_width, fig_height]);
set(hFig,'PaperUnits','inches');
set(hFig,'PaperSize', [fig_width fig_height]);
set(hFig,'PaperPositionMode', 'manual');
set(hFig,'PaperPosition',[0 0 fig_width fig_height]);
set(hFig,'Color','w');

f = uimenu('Label','Export');
uimenu(f,'Label','Adobe pdf','Callback',{@zh_exportPdf,0});
uimenu(f,'Label','Adobe pdf with time','Callback',{@zh_exportPdf,1});
uimenu(f,'Label','size control','Callback',{@zh_figSize,500,500});
end

function [] = zh_exportPdf(hObj,event,flg)
fileName = inputdlg('file name:','Name?:');
z_pdf(fileName,flg);
end

%
% function zh_figSize(hObj,event, width_, height_ )
% myWinSize = [width_ height_];
% set(gcf,'Units','pixels');
% % set(0,'Units','points')
% %         scrsz = get(0,'ScreenSize');
%
% set(gcf,'OuterPosition',...
%     [0, 0,...
%     myWinSize(1), myWinSize(2)]);
% set(gcf,'Units','normalized');
% end