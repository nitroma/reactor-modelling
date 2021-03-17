%% Axial dispersion coefficient plot

phi = 1;
M_2 = 51.80; %[g/mol]
T   = 330;   %[K]
mu  = 0.684; %[cP]
V_1 = 106.9; %[cm3/mol]

D_ab = 7.4e-8 * sqrt(phi * M_2) * T / (mu * V_1^0.6); %[cm2/s]

Q   = 0.00013165*1e6;     %[cm3/s]
D   = logspace(1,2,100);  %[cm]
u   = 4*Q./(pi*D.^2);     %[cm/s]

D_z = D_ab + (u.*D).^2/(192*D_ab); %[cm2/s]

%% plot

addpath(genpath(pwd))

plot(D/1e2,D_z/1e4)

ax = gca;
ax.XScale = 'log';
ax.XAxis.Label.String = "Diameter (m)";
ax.YAxis.Label.String = "D_z (m^2/s)";

figExport(6,6,'D_z')
