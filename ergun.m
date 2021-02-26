%% Ergun equation in multi-tubular packed bed
clear, clc, close all
addpath(genpath(pwd))

mu  = 0.000684; % [kg/m/s]
eps = 0.39; % [-]
Q   = 0.00013165; % [m3/s]
d_p = 4e-4; % [m]
rho = 1097.86; % [kg/m3]
V   = 0.924055124; % [m3]

u_0 = @(n_c, d_c) 4*Q./(n_c.*pi.*d_c.^2);
L   = @(n_c, d_c) 4*V./(n_c.*pi.*d_c.^2);
DeltaP = @(n_c, d_c) L(n_c, d_c) .*( 150*mu*(1-eps)^2.*u_0(n_c,d_c)./(eps^3*d_p^2) + 1.75*(1-eps)*rho.*u_0(n_c,d_c).^2/(eps^3*d_p) );

[n_c,d_c] = meshgrid(linspace(1,100,200),logspace(-2,0,200));

[~, c(1)] = contour(n_c,d_c,DeltaP(n_c, d_c)/1e5,logspace(-1,6,8),'ShowText',1);
c(1).DisplayName = '\DeltaP / bar';

ax = gca;
ax.XAxis.Label.String = 'n_c';
ax.YAxis.Label.String = 'd_c / m';
ax.YAxis.Scale = 'log';
ax.ColorScale = 'log';
% ax.Colormap = brewermap(8,'Reds');
ax.Colormap = colormap('cool');
legend;

% plot aspect ratio
hold on
% [~, c(2)] = contour(n_c,d_c,L(n_c,d_c)./d_c,[1 10 100],'k--','ShowText',1);
[M2, c(2)] = contour(n_c,d_c,L(n_c,d_c)./d_c,[1 10 100],'--');
c(2).DisplayName = 'L/D';
c(2).LineColor = [0.65 0.65 0.65];
clabel(M2,c(2),'Color',c(2).LineColor)


figExport(12,12,'ergun-contours-n-d')
