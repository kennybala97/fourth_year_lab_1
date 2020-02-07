function [sigma_n] = error_prop_empirical_model(T, sigma_T,lambda, sigma_lambda,combined_coefficients,B,C,D)

dn_dT = calculate_dn_dT(T, combined_coefficients);
dn_dlambda = calculate_dn_dlambda(T, B, C, D, lambda);


sigma_n = sqrt( (dn_dT.^2).*(sigma_T.^2) + (dn_dlambda.^2).*(sigma_lambda.^2) );

end

function [dn_dT] = calculate_dn_dT(T, combined_coefficients)

dn_dT_coefficients = combined_coefficients(1:3).*[(1/3) (1/2) 1];
dn_dT = polyval(dn_dT_coefficients, T);

end

function [dn_dlambda] = calculate_dn_dlambda(T, B, C, D, lambda)

B_T = -2*polyval(B,T)/(lambda^3);
C_T = -4*polyval(C,T)/(lambda^5);
D_T = -6*polyval(D,T)/(lambda^7);

dn_dlambda = D_T + C_T + B_T;

end
