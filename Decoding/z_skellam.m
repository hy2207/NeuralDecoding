function prob = z_skellam(k, mu1, mu2)
% example
% k = [4.3 5.8 6.1]; % 원래 k는 정수여야 하나, 소수도 입력받을 수 있도록 수정했다.
% mu1 = 10; % 벡터여도 된다.
% mu2 = 6; % 벡터여도 된다. 단, 사이즈는 mu1과 같아야 한다.
% z = z_skellam(k,mu1,mu2)
if isvector(k),
    k=k(:);
end

if isscalar(mu1),
    mu1 = repmat(mu1, size(k,1), 1);
    mu2 = repmat(mu2, size(k,1), 1);
elseif isvector(mu1),
    mu1 = mu1(:);
    mu2 = mu2(:);
end
mu1 = mu1 + 1e-7; % mu1가 0인 경우를 대비하여.

k1 = floor(k); % 내림
k2 = k1+1; % 내림+1

pr1 = exp(-mu1-mu2) .* (mu1./mu2).^(k1/2) .* besseli(k1, 2*sqrt(mu1.*mu2));
pr2 = exp(-mu1-mu2) .* (mu1./mu2).^(k2/2) .* besseli(k2, 2*sqrt(mu1.*mu2));

adr1 = find(isnan(pr1) | isinf(pr1)); % 불능이 발생한 경우...
pr1(adr1) = poisspdf(k1(adr1) , mu1(adr1)); % 포아송으로 다시

adr2 = find(isnan(pr2) | isinf(pr2)); % 불능이 발생한 경우...
pr2(adr2) = poisspdf(k2(adr2) , mu1(adr2)); % 포아송으로 다시

prob = pr1 + (pr2-pr1).* (k-k1);
prob(isnan(prob))=0;