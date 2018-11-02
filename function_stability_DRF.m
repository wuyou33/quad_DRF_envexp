function K = function_stability_DRF(X,param,N,flag_plot)


Ix = param.Ix; Iy = param.Iy; Iz = param.Iz; Ip = param.Ip;
k = param.k; t = param.t;
b = param.b; l = param.l; gamma = param.gamma;
Kl = param.Kl; Klc = param.Klc; Km = param.Km; Kmc = param.Kmc;

K = zeros(2,3,N);
for i=1:N
    p = X(1,i); q = X(2,i); r = X(3,i); u1 = X(4,i); u2 = X(5,i);

    dq = 0.1; dr = 0.1; du = 0.0001;
    A12 = (DP(p,q+dq,r,u1,u2,param) - DP(p,q-dq,r,u1,u2,param))/dq/2;
    A13 = (DP(p,q,r+dr,u1,u2,param) - DP(p,q,r-dr,u1,u2,param))/dr/2;
    B11 = (DP(p,q,r,u1+du,u2,param) - DP(p,q,r,u1-du,u2,param))/du/2;
    B12 = (DP(p,q,r,u1,u2+du,param) - DP(p,q,r,u1,u2-du,param))/du/2;
    
    A = [ 0                            (Iy-Iz)/Ix*r- Ip/Ix*(u1+u2)  (Iy-Iz)/Ix*q + (Kl*b - Klc*l)*u1/Ix + (-Kl*b + Klc*l)*u2/Ix;
         (Iz-Ix)/Iy*r + Ip/Iy*(u1+u2)   0                           (Iz-Ix)/Iy*p + (Km*l - Kmc*b)*u1/Iy + (-Km*l + Kmc*b)*u2/Iy;
         (Ix-Iy)/Iz*q                   (Ix-Iy)/Iz*p                -gamma/Iz];

    B = [(-Ip*q + 2*k*b*u1)/Ix + (Kl*b - Klc*l)*r/Ix,   (-Ip*q-2*k*b*u2)/Ix + (-Kl*b + Klc*l)*r/Ix;
         (Ip*p + 2*k*l*u1)/Iy + (Km*l - Kmc*b)*r/Iy,    (Ip*p - 2*k*l*u2)/Iy + (-Km*l + Kmc*b)*r/Iy;
         2*t*u1/Iz,             2*t*u2/Iz];

    Q = eye(3); R = 0.01*eye(2);

    K(:,:,i) = lqr(A,B,Q,R);
    
    EIG_op(:,i) = eig(A);
    EIG_cl(:,i) = eig(A-B*K(:,:,i));

    j = 1;
    if u2 > u1
        j = 2;
    end

    B(:,j) = zeros(3,1);
    EIG_cl_sat(:,i) = eig(A-B*K(:,:,i));

end


if flag_plot == 1
    figure;
    plot_roots(EIG_op,N,'k^');
    plot_roots(EIG_cl,N,'bo');
    plot_roots(EIG_cl_sat,N,'r*');
end
end

function plot_roots(EIG,N,marker)
for i = 1:N
   realX = real(EIG(:,i));
   imagX = imag(EIG(:,i));
   plot(realX,imagX,marker); hold on;       
end
end

function y = DP(p,q,r,u1,u2,param)

    Ix = param.Ix; Iy = param.Iy; Iz = param.Iz; Ip = param.Ip;
    k = param.k; t = param.t;
    b = param.b; l = param.l; gamma = param.gamma;
    Kl = param.Kl; Klc = param.Klc; Km = param.Km; Kmc = param.Kmc;

    y = ((Iy-Iz)*q*r - Ip*q*(u1+u2) + k*b*(u1^2-u2^2))/Ix + (Kl*b*r - Klc*l*r)*u1/Ix + (-Kl*b*r + Klc*l*r)*u2/Ix;
end