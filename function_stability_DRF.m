function K = function_stability_DRF(X,param,N,flag_plot)


Ix = param.Ix; Iy = param.Iy; Iz = param.Iz; Ip = param.Ip;
k = param.k; t = param.t;
b = param.b; l = param.l; gamma = param.gamma;
K = zeros(2,3,N);
for i=1:N
    p = X(1,i); q = X(2,i); r = X(3,i); u1 = X(4,i); u2 = X(5,i);

    A = [ 0                            (Iy-Iz)/Ix*r- Ip/Ix*(u1+u2)  (Iy-Iz)/Ix*q;
         (Iz-Ix)/Iy*r + Ip/Iy*(u1+u2)   0                           (Iz-Ix)/Iy*p;
         (Ix-Iy)/Iz*q                   (Ix-Iy)/Iz*p                -gamma/Iz];

    B = [(-Ip*q + 2*k*b*u1)/Ix,   (-Ip*q-2*k*b*u2)/Ix;
         (Ip*p + 2*k*l*u1)/Iy,    (Ip*p - 2*k*l*u2)/Iy;
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