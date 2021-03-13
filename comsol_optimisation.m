%% Multivariate optimisation using a COMSOL simulation
clear, clc, diary on

% initial parameter values
pname = ["d_i" "m_c_in" "Tc_in" "Tc"];
punit = ["[m]" "[kg/s]" "[K]"   "[K]"];
x0    = [0.02  0.15     325     330];
lb    = [5e-3  0.05     273     273];
ub    = [5e-2  0.50     373     373];

% create function wrapper
wrapped_comsol = @(x) do_comsol(x,pname,punit);

% don't bother with the inequality or equality constrains
A = zeros(1,4); b = 0;
Aeq = A; beq = b;

% do optimisation
x = gamultiobj(wrapped_comsol,4,A,b,Aeq,beq,lb,ub);
writematrix(x,'comsol_optimised_values.txt');

diary off

function F = do_comsol(x,pname,punit)
% key reference: https://uk.comsol.com/blogs/how-to-run-comsol-multiphysics-from-the-command-line/

% read input
pvals = string(num2str(x(:),'%1.3e'))';

% generate command
command = strcat("comsolbatch -inputfile in.mph -pname ",join(pname,',')," -plist ",join(strcat('"',join([pvals;punit],'',1),'"'),',')," -methodcall my_method -nosave");
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
