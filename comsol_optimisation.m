%% Multivariate optimisation using a COMSOL simulation
clear, clc, diary on

% initial parameter values
pname = ["d_i" "m_c_in" "Tc"];
punit = ["[m]" "[kg/s]" "[K]"];
x0    = [0.02  0.15     325];
lb    = [5e-3  0.05     289];
ub    = [5e-2  0.50     350];

% create function wrapper
wrapped_comsol = @(x) do_comsol(x,pname,punit);

% don't bother with the inequality or equality constrains
A = zeros(1,3); b = 0;
Aeq = A; beq = b;

% set options
options = optimoptions(@gamultiobj,'MaxGenerations',72,'MaxStallGenerations',3,'MaxTime',6*60^2);

% do optimisation
[x,fval,exitflag,output,population,scores] = gamultiobj(wrapped_comsol,length(x0),A,b,Aeq,beq,lb,ub,options);
writematrix(x,'comsol_optimised_x.txt');
writematrix(fval,'comsol_optimised_fval.txt');
writematrix(population,'comsol_optimised_population.txt');
writematrix(scores,'comsol_optimised_scores.txt');

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

% return 2 objectives
F = str2double(t{1,1:2});
fprintf('do_comsol\t[inputs]\t');fprintf('%1.3e\t',x);
fprintf('[outputs]\t');fprintf('%1.3e\t',F);fprintf('\n');

end
