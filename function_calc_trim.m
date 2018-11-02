function Y = function_calc_trim(X,param,u1_u2)

p = X(1);
q = X(2);
r = X(3);
u1 = X(4);
u2 = X(5);

Ix = param.Ix; Iy = param.Iy; Iz = param.Iz;Ip = param.Ip;
k = param.k; b = param.b; l = param.l;t = param.t; m = param.m; 
g = param.g; gamma = param.gamma;
Kl = param.Kl; Klc = param.Klc; Km = param.Km; Kmc = param.Kmc;

Y = zeros(5,1);
Y(1) = ((Iy-Iz)*q*r - Ip*q*(u1+u2) + k*b*(u1^2-u2^2))/Ix + (Kl*b*r - Klc*l*r)*u1/Ix + (-Kl*b*r + Klc*l*r)*u2/Ix;
Y(2) = ((Iz-Ix)*p*r + Ip*p*(u1+u2) + k*l*(u1^2-u2^2))/Iy + (Km*l*r - Kmc*b*r)*u1/Iy + (-Km*l*r + Kmc*b*r)*u2/Iy;
Y(3) = (-gamma*r + t*(u1^2+u2^2) + (Ix-Iy)*p*q)/Iz;
Y(4) = m*g*norm([p,q,r])/abs(r) - k*(u1^2+u2^2);
Y(5) = u1 - u2*u1_u2;
end