function hAxe_ = z_sub(nRow, nCol, idxSub, option)

global fig_width fig_height
if isempty(fig_width) && isempty(fig_height),
    error('Call z_canvas function first.');
end

if nargin < 4,
    option = zeros(1,6);
end

margin_horz_L = 0.55 + option(1);
margin_horz_R = 0.25 + option(2);
margin_vert_U = 0.40 + option(3);
margin_vert_D = 0.45 + option(4);
gap_horz      = 1.00 + option(5);
gap_vert      = 1.00 + option(6);

% isscalar([2 1])
N=numel(idxSub);
ax_posSet = cell(N,1);
hAxeSet = cell(N,1);
for idx=1:N,
    idxSubp = idxSub(idx);
    tmpR = ceil(idxSubp/nCol);
    tmpC = idxSubp-(tmpR-1)*nCol;
    
    sub_width = (fig_width - margin_horz_L - margin_horz_R - gap_horz*(nCol-1))/nCol;
    sub_height = (fig_height - margin_vert_U - margin_vert_D - gap_vert*(nRow-1))/nRow;
    margin_horz_l = margin_horz_L + (tmpC-1)*(gap_horz+sub_width); % inch
    margin_horz_r = fig_width - sub_width - margin_horz_l; % inch
    margin_vert_u = margin_vert_U + (tmpR-1)*(gap_vert+sub_height); % inch
    margin_vert_d = fig_height - sub_height - margin_vert_u; % inch
    
    hAxeSet{idx} = axes;
    set(hAxeSet{idx},'activepositionproperty','outerposition');
    set(hAxeSet{idx},'units','inches');
    ax_pos = get(hAxeSet{idx},'position');
    
    ax_pos(4) = fig_height-margin_vert_u-margin_vert_d;
    ax_pos(2) = fig_height-(margin_vert_u+ax_pos(4));
    ax_pos(3) = fig_width-margin_horz_l-margin_horz_r;
    ax_pos(1) = margin_horz_l;
    ax_posSet{idx} = ax_pos;
end

hAxe_ = hAxeSet{N};
pos_ = ax_posSet{N};
if N~=1,
    pos_(4) = pos_(4)*N+gap_vert*(N-1);
end

set(hAxe_,'position',pos_);
for idx=1:N-1, % 임시 axes는 삭제
    delete(hAxeSet{idx}); %set(hAxeSet{idx},'Visible','off');
end

set(hAxe_,'units','normalized');

if nargout < 1,
    hAxe_ = [];
end