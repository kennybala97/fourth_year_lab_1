clear all;
close all;
clc;

load('distilled_water_data.mat', 'distilled_water_data');

T0 = 1.3500000E+02;
V0 = 5.9588600E+00;
p1 = 2.0325591E+01;
p2 = 3.3013079E+00;
p3 = 1.2638462E-01;
p4 = -8.2883695E-04;
q1 = 1.7595577E-01;
q2 = 7.9740521E-03;
q3 = 0.0;


% convert to millivolts

temp_mv = distilled_water_data.temp/1e-3;

delta_v = temp_mv - V0;

d = 5e-2;
lambda = 632;

sigma_d = 0.5e-3; % half a milimetre
sigma_lambda = 10.53e-9; % In nanometres

numerator = delta_v.*( p1 + delta_v.*( p2 + delta_v.*(p3 + p4.*delta_v)));
denominator = 1 + delta_v.*(q1 + delta_v.*(q2 + q3.*delta_v));
temperature = T0 + numerator./denominator;
temperature_filtered = sgolayfilt(temperature,2,501);

sigma_T = std(abs(temperature - temperature_filtered));

time = distilled_water_data.time;


% The calculations with experimental data

filtered_data = sgolayfilt(distilled_water_data.fringes,2,31);
[pks_1,locs_1] = findpeaks(filtered_data(1:3000),'MinPeakWidth',10);
[pks_2,locs_2] = findpeaks(filtered_data(3001:6000),'MinPeakWidth',15);
[pks_3,locs_3] = findpeaks(filtered_data(6001:10000),'MinPeakWidth',25);

pks = [pks_1; pks_2; pks_3];
locs = [locs_1; locs_2+3000;locs_3+6000];

pks(28) = [];
locs(28) = [];
pks(end-1) = [];
locs(end-1) = [];

[group_id, grouped_data] = f_group_datasets(temperature_filtered(locs),ones(length(pks),1), 5);

A = flip([1.3208, -1.2325e-5,-1.8674e-6,5.0233e-9]);
B = flip([5208.2413, -0.5179, -2.284e-2, 6.9608e-5])/lambda^2;
C = flip([-2.5551e8, -18341.336, -917.2319, 2.7729])/lambda^4;
D = flip([9.3495, 1.7855e-3, 3.6733e-5, -1.2932e-7])/lambda^6;

coefficients_empirical = A + B + C + D;
n_theory = polyval(coefficients_empirical,temperature_filtered);
[sigma_n_theory] = error_prop_empirical_model(temperature_filtered, sigma_T,lambda, sigma_lambda,coefficients_empirical,B,C,D);

n_o = n_theory(end);

delta_M = cumsum(0:1:length(pks) - 1);
delta_n = cumsum((grouped_data*(lambda*1e-9)/d));
n = n_o - delta_n;

[sigma_n_exp] = error_prop_experimental_calcs(d,lambda*1e-9, sigma_d, sigma_lambda);

sigma_n_exp = ones(1,length(n))*sigma_n_exp;

data_fit = fit(group_id, n,'poly3');

coefficients_fit = coeffvalues(data_fit);

n_fit = polyval(coefficients_fit,temperature_filtered);

for k = 2:1:length(sigma_n_exp)
   sigma_n_exp(k) = sqrt((sigma_n_exp(k))^2 + (sigma_n_exp(k-1))^2);
end

figure(1);
plot(time/60, filtered_data,'b');hold on;
scatter(time(locs)/60,pks,'r*');
xlabel('Time(m)');
ylabel('Photodetector Voltage(V)');
title('Fringe Observations vs. Time');
legend('Photodetector Voltage','Fringe Transitions');
grid on;

figure(2);

plot(temperature_filtered,n_theory,'b','LineWidth',2);
hold on;
plot(temperature_filtered,n_theory + sigma_n_theory,'k--','LineWidth',0.5);
plot(temperature_filtered,n_theory - sigma_n_theory,'k--','LineWidth',0.5);
hold on;
errorbar(group_id,n,sigma_n_exp,'r.');
hold on;
plot(temperature_filtered, n_fit,'g--','LineWidth',2);
xlabel('Temperature(C)');
ylabel('Refractive Index');
title('Refractive Index Comparison - Empirical Model vs. Experimental Data');
legend('Empirical Model', 'Empirical Model + \sigma_{n,emp}', 'Empirical Model - \sigma_{n,emp}','Experimental Data','Curve Fit of Experimental Data');
grid on;

figure(3);
scatter(time/60, temperature,'b.');
hold on;
plot(time/60, temperature_filtered,'r','Linewidth',2);
xlabel('Time(m)');
ylabel('Temperature(C)');
title('Temperature of Water Sample vs. Time');
legend('Measured Temperature', 'Filtered Temperature');
grid on;
