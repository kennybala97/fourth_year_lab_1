clear all;
close all;
clc;

distance_per_pixel = 460/42.0083;

dist = 0:distance_per_pixel:(distance_per_pixel*300);

inc_100 = imread('jan20_mz_inc_100_no_etalon_beam.bmp');
inc_200 = imread('jan20_mz_inc_200_no_etalon_beam.bmp');
inc_300 = imread('jan20_mz_inc_300_no_etalon_beam.bmp');
inc_400 = imread('jan20_mz_inc_400_no_etalon_beam.bmp');
inc_500 = imread('jan20_mz_inc_500_no_etalon_beam.bmp');

vec = [100 100 300 300];

inc_100 = imcrop(inc_100,vec);
inc_200 = imcrop(inc_200,vec);
inc_300 = imcrop(inc_300,vec);
inc_400 = imcrop(inc_400,vec);
inc_500 = imcrop(inc_500,vec);

inc_100_gray = rgb2gray(inc_100);
inc_200_gray = rgb2gray(inc_200);
inc_300_gray = rgb2gray(inc_300);
inc_400_gray = rgb2gray(inc_400);
inc_500_gray = rgb2gray(inc_500);

inc_100_sum = sum(inc_100_gray, 1);
inc_200_sum = sum(inc_200_gray, 1);
inc_300_sum = sum(inc_300_gray, 1);
inc_400_sum = sum(inc_400_gray, 1);
inc_500_sum = sum(inc_500_gray, 1);

[fitresult_inc_100, gof_inc_100, xData_inc_100, yData_inc_100, excludedPoints_inc_100] = fit_100um(dist, inc_100_sum);
[fitresult_inc_200, gof_inc_200, xData_inc_200, yData_inc_200, excludedPoints_inc_200] = fit_100um(dist, inc_200_sum);
[fitresult_inc_300, gof_inc_300, xData_inc_300, yData_inc_300, excludedPoints_inc_300] = fit_100um(dist, inc_300_sum);
[fitresult_inc_400, gof_inc_400, xData_inc_400, yData_inc_400, excludedPoints_inc_400] = fit_100um(dist, inc_400_sum);
[fitresult_inc_500, gof_inc_500, xData_inc_500, yData_inc_500, excludedPoints_inc_500] = fit_100um(dist, inc_500_sum);


fit_distance = [100 200 300 400 500];
fit_slope = [0.01457 0.01308 0.01363 0.01313, 0.01302]/(2*pi);
fit_std = ([0.01482, 0.01331, 0.01399, 0.01361, 0.01348] - [0.01433, 0.01285, 0.01326, 0.01264, 0.01257])/(4*pi);

[fitresult, gof] = final_slope_fit(fit_distance, fit_slope, fit_std);

data.r.val = fit_distance;
data.r.err = ones(1,5)*distance_per_pixel;
data.r.unit = '\mu{m}';
data.Vx.val = fit_slope;
data.Vx.err = fit_std;
data.Vx.unit = '\mu{m}';

generate_table(1,{'Measured \Delta{L}','Curve Fitted \Delta{L}'},[true,true],'Intensity Profile Curve Fit Results - January 20 Data','jan_20_curve_fit_table',data.r,data.Vx);

figure(1);

fontsize = 7;

subplot(5,2,1);
image(dist,dist,inc_100);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 100\mu{m}','Fontsize',fontsize);

subplot(5,2,2);
plot(dist,inc_100_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 100\mu{m}','Fontsize',fontsize);

subplot(5,2,3);
image(dist,dist,inc_200);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 200\mu{m}','Fontsize',fontsize);
subplot(5,2,4);
plot(dist,inc_200_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 200\mu{m}','Fontsize',fontsize);

subplot(5,2,5);
image(dist,dist,inc_300);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 300\mu{m}','Fontsize',fontsize);
subplot(5,2,6);
plot(dist,inc_300_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 300\mu{m}','Fontsize',fontsize);

subplot(5,2,7);
image(dist,dist,inc_400);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 400\mu{m}','Fontsize',fontsize);
subplot(5,2,8);
plot(dist,inc_400_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 400\mu{m}','Fontsize',fontsize);

subplot(5,2,9);
image(dist,dist,inc_500);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 500\mu{m}','Fontsize',fontsize);
subplot(5,2,10);
plot(dist,inc_500_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 500\mu{m}','Fontsize',fontsize);

sgtitle('Data Taken January 20, 2019 - Interference Pattern vs. Path Length Separation');

print(figure(1), 'interference_pattern_jan_20_data','-dpdf','-fillpage');


% Plot fit with data.
figure(2);

subplot(5,1,1);
plot( fitresult_inc_100, xData_inc_100, yData_inc_100, excludedPoints_inc_100 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
title('Fourier Series Curve Fit - \Delta{L} = 100\mu{m}','Fontsize',fontsize);
grid on


subplot(5,1,2);
plot( fitresult_inc_200, xData_inc_200, yData_inc_200, excludedPoints_inc_200 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
grid on
title('Fourier Series Curve Fit - \Delta{L} = 200\mu{m}','Fontsize',fontsize);


subplot(5,1,3);
plot( fitresult_inc_300, xData_inc_300, yData_inc_300, excludedPoints_inc_300 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
grid on
title('Fourier Series Curve Fit - \Delta{L} = 300\mu{m}','Fontsize',fontsize);


subplot(5,1,4);
plot( fitresult_inc_400, xData_inc_400, yData_inc_400, excludedPoints_inc_400 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
grid on
title('Fourier Series Curve Fit - \Delta{L} = 400\mu{m}','Fontsize',fontsize);

subplot(5,1,5);
plot( fitresult_inc_500, xData_inc_500, yData_inc_500, excludedPoints_inc_500 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
grid on
title('Fourier Series Curve Fit - \Delta{L} = 500\mu{m}','Fontsize',fontsize);
sgtitle('Data Taken January 20, 2019 - Fourier Series Curve Fits');

print(figure(2),'curve_fits_jan_20_data','-dpdf','-fillpage');



figure(3);
errorbar(fit_distance, fit_slope, fit_std,'r.');
hold on;
plot(0:1:600, (-4.752e-07)*(0:1:600) + 0.002293, 'b--');
title('Fringe Pattern \Delta{L} Results Curve Fit - January 20 Data','Fontsize',fontsize);
xlabel( 'Measured Path Length Difference(\mu{m})');
ylabel( 'Path Length Difference Prediction From Curve Fit(\mu{m})');

saveas(figure(3),'line_curve_fit_jan20','epsc');

