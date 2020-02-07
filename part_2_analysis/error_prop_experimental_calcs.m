function [sigma_n] = error_prop_experimental_calcs(d,lambda, sigma_d, sigma_lambda)

dn_dlambda = 1/d;
dn_dd = -lambda/(d^2);

sigma_n = sqrt( (dn_dlambda.^2).*(sigma_lambda.^2) + (dn_dd.^2).*(sigma_d.^2) );

end

