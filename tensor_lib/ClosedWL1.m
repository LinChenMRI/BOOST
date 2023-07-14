function X=ClosedWL1(Y,C,oureps)
% 应该是子问题1的公式，C为b，Y为外围的S
% solving the following problem
%         sum(w*|Y_i|)+1/2*||Y-X||_F^2
% where w_i =C/(sigmaX_i+oureps),oureps is a small constant
absY      = abs(Y); % c1
signY     = sign(Y);
temp      = (absY-oureps).^2-4*(C-oureps*absY);% 论文里的c2
ind       = temp>0;% 如果c2>0
% svp       = sum(ind(:));
% absY      = absY.*ind;
absY      = (absY-oureps+sqrt(temp))/2.*ind;% 判断式D
X         = absY.*signY;
end