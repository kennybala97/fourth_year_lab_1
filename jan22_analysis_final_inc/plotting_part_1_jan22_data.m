clear all;
close all;
clc;

distance_per_pixel = 460/42.0083;

dist = 0:distance_per_pixel:(distance_per_pixel*479);

inc_0 = imread('initial_jan22.bmp');
inc_1000 = imread('final_inc1mm_jan22.bmp');

inc_0 = imcrop(inc_0, [161 0 580 480]);
inc_1000 = imcrop(inc_1000, [161 0 580 480]);

inc_0_gray = rgb2gray(inc_0);
inc_1000_gray = rgb2gray(inc_1000);

inc_0_sum = sum(inc_0_gray, 1);
inc_1000_sum = sum(inc_1000_gray, 1);

figure(1);

fontsize = 7;

subplot(2,2,1);
image(dist,dist,inc_0);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 100\mu{m}','Fontsize',fontsize);

subplot(2,2,2);
plot(dist,inc_0_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 100\mu{m}','Fontsize',fontsize);

subplot(2,2,3);
image(dist,dist,inc_1000);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Vertical Distance(\mu{m})','Fontsize',fontsize);
title('Fringe Pattern on CCD Camera - \Delta{L} = 200\mu{m}','Fontsize',fontsize);
subplot(2,2,4);
plot(dist,inc_1000_sum);
xlabel('Horizontal Distance(\mu{m})','Fontsize',fontsize);
ylabel('Image Intensity(Unitless)','Fontsize',fontsize);
title('Projection of Fringe Pattern - \Delta{L} = 200\mu{m}','Fontsize',fontsize);
sgtitle('Data Taken January 22, 2019 - Interference Pattern vs. Path Length Separation');

print('interference_pattern_jan_22_data','-dpdf','-fillpage');


[fitresult_inc_0, gof_inc_0, xData_inc_0, yData_inc_0, excludedPoints_inc_0] = fit_0um(dist, inc_0_sum);
[fitresult_inc_1000, gof_inc_1000, xData_inc_1000, yData_inc_1000, excludedPoints_inc_1000] = fit_1000um(dist, inc_1000_sum);

% Plot fit with data.
figure(2);

subplot(2,1,1);
plot( fitresult_inc_0, xData_inc_0, yData_inc_0, excludedPoints_inc_0 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
title('Fourier Series Curve Fit - \Delta{L} = 0\mu{m}(Uncalibrated)','Fontsize',fontsize);
grid on


subplot(2,1,2);
plot( fitresult_inc_1000, xData_inc_1000, yData_inc_1000, excludedPoints_inc_1000 );
legend('Data Points', 'Excluded Data', 'Obtained Curve Fit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Horizontal Distance(\mu{m})');
ylabel( 'Intensity (Unitless)');
grid on
title('Fourier Series Curve Fit - \Delta{L} = 1000\mu{m}','Fontsize',fontsize);


sgtitle('Data Taken January 22, 2019 - Fourier Series Curve Fits, 0-1000\mu{m}');

print(figure(2),'curve_fits_jan_20_data','-dpdf','-fillpage');

