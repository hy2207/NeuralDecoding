function prob = z_skellam(k, mu1, mu2)
% example
% k = [4.3 5.8 6.1]; % ���� k�� �������� �ϳ�, �Ҽ��� �Է¹��� �� �ֵ��� �����ߴ�.
% mu1 = 10; % ���Ϳ��� �ȴ�.
% mu2 = 6; % ���Ϳ��� �ȴ�. ��, ������� mu1�� ���ƾ� �Ѵ�.
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
mu1 = mu1 + 1e-7; % mu1�� 0�� ��츦 ����Ͽ�.

k1 = floor(k); % ����
k2 = k1+1; % ����+1

pr1 = exp(-mu1-mu2) .* (mu1./mu2).^(k1/2) .* besseli(k1, 2*sqrt(mu1.*mu2));
pr2 = exp(-mu1-mu2) .* (mu1./mu2).^(k2/2) .* besseli(k2, 2*sqrt(mu1.*mu2));

adr1 = find(isnan(pr1) | isinf(pr1)); % �Ҵ��� �߻��� ���...
pr1(adr1) = poisspdf(k1(adr1) , mu1(adr1)); % ���Ƽ����� �ٽ�

adr2 = find(isnan(pr2) | isinf(pr2)); % �Ҵ��� �߻��� ���...
pr2(adr2) = poisspdf(k2(adr2) , mu1(adr2)); % ���Ƽ����� �ٽ�

prob = pr1 + (pr2-pr1).* (k-k1);
prob(isnan(prob))=0;