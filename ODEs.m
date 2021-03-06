%% reactor modelling ODEs
function ODEs()

% index i: species
species = ["TOL" "NA" "ONTOL" "MNTOL" "PNTOL" "W"];
I = length(species);

% index j: reactions
reactions = ["O" "M" "P"];
J = length(reactions);

% set up initial condition
a0 = zeros(2*I+1,1);
a0(1:2) = 0.2;
a0(6)   = 0.5;
a0(end) = 330;

% nitrationODEs(1,a0)

% solve ODEs
[z,a] = ode15s(@(z,a) nitrationODEs(z,a),linspace(1,10,101),a0);

% plot output
fig = figure;
yyaxis left
plot(z,a(:,1:I));
yyaxis right
plot(z,a(:,end));

function dadz = nitrationODEs(z,a)
    
%     disp(a)
%     disp(z)

% grab inputs
C   = a(1:I);       % [mol/m3] 
C_  = a(I+1:2*I);   % [mol/m4]
T   = a(2*I+1)';    % [K]
 
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
     0  0  1;  % PNTOLv
     1  1  1]; % W
rI = nu * rJ;  % [mol/(m3.s)]

% heat production
dh = [-111.8242767; -120.5370167; -120.4684727]*1e3; % [J/mol]
DH = dot(rJ,dh); % [J/(m3.s)]

% compute derivatives
dCdz    = C_; % [mol/m4]
dC_dz   = 1/D_ez * ( u_s * C_ - rI ); % [mol/m4]
dTdz = DH/(u_s*rho_f*c_p) * (1-lambda/kappa); % [K/m]

% return derivatives in single column vector for 
dadz = zeros(size(a));
dadz(1:I)       = dCdz;     % [mol/m4] 
dadz(I+1:2*I)   = dC_dz;    % [mol/m5]
dadz(2*I+1)     = dTdz;     % [K/m]

end

end
