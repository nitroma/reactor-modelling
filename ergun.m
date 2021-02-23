%% Ergun equation in multi-tubular packed bed

syms DeltaP L mu eps u_0 d_p rho Q A A_c n_c d_c

% eqn = sym.empty(0,4);
eqn(1) = DeltaP/L == 150*mu*(1-eps)^2*u_0/(eps^3*d_p^2) + 1.75*(1-eps)*rho*u_0^2/(eps^3*d_p);
eqn(2) = u_0 == Q/A;
eqn(3) = A == n_c * A_c;
eqn(4) = A_c == pi*d_c^2/4;

L   = 1; % [-]
mu  = 0.000684; % [kg/m/s]
eps = 0.39; % [-]
Q   = 0.00013165; % [m3/s]
d_p = 3e-6; % [m]
rho = 1097.86; % [kg/m3]

n_c = 21; % [-]
d_c = 0.07; % [m]

solve(eqn, DeltaP)
