function prob = z_skellam(k, mu1, mu2)

if isvector(k)
    k=k(:);
end

if isscalar(mu1)
    mu1 = repmat(mu1, size(k,1), 1);
    mu2 = repmat(mu2, size(k,1), 1);
elseif isvector(mu1)
    mu1 = mu1(:);
    mu2 = mu2(:);
end
mu1 = mu1 + 1e-7; % exeception when mu1 is 0

k1 = floor(k); 
k2 = k1+1; 

pr1 = exp(-mu1-mu2) .* (mu1./mu2).^(k1/2) .* besseli(k1, 2*sqrt(mu1.*mu2));
pr2 = exp(-mu1-mu2) .* (mu1./mu2).^(k2/2) .* besseli(k2, 2*sqrt(mu1.*mu2));

%execption -> poisson
adr1 = find(isnan(pr1) | isinf(pr1)); 
pr1(adr1) = poisspdf(k1(adr1) , mu1(adr1)); 

adr2 = find(isnan(pr2) | isinf(pr2)); 
pr2(adr2) = poisspdf(k2(adr2) , mu1(adr2)); 

prob = pr1 + (pr2-pr1).* (k-k1);
prob(isnan(prob))=0;