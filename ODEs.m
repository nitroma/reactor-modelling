%% reactor modelling ODEs



function dadz = nitrationODEs(z,a)

% index i: species
species = ["TOL" "NA" "ONTOL" "MNTOL" "PNTOL" "W"];
I = length(species);

% index j: reactions
reactions = ["O" "M" "P"];
J = length(reactions);

% grab inputs
C(1:I)  = a(1:I); % [mol/m3] 
T       = a(I+1); % [K]
 
% constants
u_s     = 1;
rho_f   = 1;
c_p     = 1;
lambda  = 1;
kappa   = 3; % [W/(m.K)]
D_ez    = 1;
R       = 8.314; % [J/(mol.K)]

% rate per reaction
A  = [1.739; 4.968; 7.024]; % [1/s]
Ea = [24215; 32370; 27962]; % [J/mol]
k  = A .* exp( -Ea/(R*T) ); % [1/s]
rJ = k * C(1); % [mol/(m3.s)]

% rate per species
nu = [...
    -1 -1 -1;  % TOL
    -1 -1 -1;  % NA
     1  0  0;  % ONTOL
     0  1  0;  % MNTOL
     0  0  1;  % PNTOL
     1  1  1]; % W
rI = nu * rJ;  % [mol/(m3.s)]

% heat production
dh = [-111.8242767; -120.5370167; -120.4684727]*1e3; % [J/mol]
DH = dot(rJ,dh); % [J/(m3.s)]

% compute derivatives
dTdz = 

end