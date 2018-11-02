close all
clear all
addpath('E:\Data\_data_drone_parameters');
load('Bebop2_leon_parameters.mat');
lqr_data = load('lqr_data');
%%

dt_simu = 0.001;

i = find(lqr_data.u1_u2 == 1);
p0 = lqr_data.X(1,i);
q0 = lqr_data.X(2,i);
r0 = lqr_data.X(3,i);
u1 = lqr_data.X(4,i);
u2 = lqr_data.X(5,i);
K  = lqr_data.K;

phi0 = atan(q0/r0);
theta0 = -atan(p0/r0/(q0/r0*sin(phi0)+cos(phi0)));

X0 = [phi0 theta0 0 p0 q0 r0]';
% X0 = [p0 q0 r0]';
%%

Simulink.Bus.createObject(lqr_data);
lqr_data_bus = slBus1; 
clear slBus1;

param.Ix = parameters.Iv(1,1); 
param.Iy = parameters.Iv(2,2); 
param.Iz = parameters.Iv(3,3);
param.Ip = parameters.Ip(3,3);
param.b = parameters.b; 
param.l = parameters.l;
param.m = parameters.m; 

param.k = 1.9035e-6;
param.t = 1.9202951e-8;
param.gamma = 1.918988e-3;
param.g = 9.8124;

Simulink.Bus.createObject(param);
param_bus = slBus1; 
clear slBus1;

%% init visualization
animation_figure_id = 99;
close(figure(animation_figure_id));
figure(animation_figure_id)
ax = axes('XLim',[-5,5],'YLim',[-5,5],'ZLim',[-5,5]);

xlim([-1,1]); ylim([-1,1]); zlim([-1,1])
[h_animation] = quad_figure(0,0,0,'roll',0,'pitch',0,'yaw',0,'scale',0.03*3,'prop',[2,4]);
set(gca, 'Zdir', 'reverse');
set(gca, 'Ydir', 'reverse');
set(gca, 'Projection','perspective');
camlight
t_animation = hgtransform('Parent',ax);
set(h_animation,'Parent',t_animation);

S = makehgtform('translate',[0,0,0]);
Rz = makehgtform('zrotate',0);
Ry = makehgtform('yrotate',theta0);
Rx = makehgtform('xrotate',phi0);

set(t_animation,'Matrix',S*Rz*Ry*Rx);
% set(t,'Matrix',S);
drawnow
