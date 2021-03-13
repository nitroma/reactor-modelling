%% Multivariate optimisation using a COMSOL simulation

% initial parameter values
pname = ["d_i" "m_c_in" "Tc_in" "Tc"];
punit = ["[m]" "[kg/s]" "[K]"   "[K]"];
x0    = [0.02; 0.15;    325;    330];

% create function wrapper
wrapped_comsol = @(x) do_comsol(x,pname,punit);

% set up for optimisation
goal = [363, 3]; % T, X_TOL<0.98
weight = goal;

% do optimisation
x = fgoalattain(wrapped_comsol,x0,goal,weight);
writematrix(x,'comsol_optimised_values.txt');

function F = do_comsol(x,pname,punit)
% key reference: https://uk.comsol.com/blogs/how-to-run-comsol-multiphysics-from-the-command-line/

% read input
pvals = string(num2str(x,'%1.3e'));

% generate command
command = strcat("comsolbatch -inputfile in.mph -pname ",join(pname,',')," -plist ",join(strcat('"',strcat(pvals,punit'),'"'),',')," -methodcall my_method -nosave");
disp(command)

% execute command
status = system(command);

% grab output from COMSOL
% opts = detectImportOptions('table4.txt'); % auto-detect fails
opts = delimitedTextImportOptions('NumVariables',2);
opts.DataLines = [6 Inf];
opts.Delimiter = {' ' '%'};
opts.ConsecutiveDelimitersRule = 'join';
opts.LeadingDelimitersRule = 'ignore';
t = readtable('table4.txt',opts);

% return numeric output
F = str2double(t{1,:});

end