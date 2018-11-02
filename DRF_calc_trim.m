close all
clear all
addpath('E:\Data\_data_drone_parameter');
load('Bebop2_leon_parameters.mat');

param.Ix = parameters.Iv(1,1); 
param.Iy = parameters.Iv(2,2); 
param.Iz = parameters.Iv(3,3);
param.Ip = parameters.Ip(3,3);
param.b = parameters.b; 
param.l = parameters.l;
param.m = parameters.m*0.79; 

param.k = 1.9035e-6;
param.t = 1.9202951e-8;
param.gamma = 1.918988e-3;
param.g = 9.8124;

%% calculate the trim point
u1_u2 = [1.0:0.1:1.5];
N = length(u1_u2);
X = zeros(5,N);
x0 = [0 0 25 800 800];
for i = 1:N
    if i>1
        x0 = X(:,i-1);
    end
    [X(:,i),FVAL,EXITFLAG] = fsolve(@(x)function_calc_trim(x,param,u1_u2(i)),x0);
end
%% analyse the stability
K = function_stability_DRF(X,param,N,1);
save lqr_data X K u1_u2;