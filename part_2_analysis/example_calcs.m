clear all;
close all;
clc;

lambda = 632.8;
T = 35;

A = flip([1.3208, -1.2325e-5,-1.8674e-6,5.0233e-9]);
B = flip([5208.2413, -0.5179, -2.284e-2, 6.9608e-5])/lambda^2;
C = flip([-2.5551e8, -18341.336, -917.2319, 2.7729])/lambda^4;
D = flip([9.3495, 1.7855e-3, 3.6733e-5, -1.2932e-7])/lambda^6;

coefficients_empirical = A + B + C + D;
n_theory = polyval(coefficients_empirical,T)