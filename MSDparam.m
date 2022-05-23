% MSDparam.m
clear 
clc

% User-defined variables
DataPath = "D:\MSD";

%% Script initialization
% Creates progress bar for a better overview of the script's progress
fig = uifigure;
progressbar = uiprogressdlg(fig,'Title','COMSOL parametric study',...
        'Message','Opening the application');

%% Variable initialization and memory pre-allocation
% Loading data from the specified directory
progressbar.Value = 0.1; 
progressbar.Message = 'Loading data';

% Get data files
X = table2array(readtable(fullfile(DataPath,'x_param.csv'),'ReadVariableNames',false,'HeaderLines', 5));
Y = table2array(readtable(fullfile(DataPath,'y_param.csv'),'ReadVariableNames',false,'HeaderLines', 5));

% Getting some info about the data for processing
progressbar.Value = .2; 
progressbar.Message = 'Processing data';

Nparticles = size(X,2)-2; 		% Number of particles equals number of columns - 2 (parameter and time column)
Nparams = size(unique(X(:,1)),1); 	% Number of different parameters
Nframes = (size(X,1)/Nparams); 		% Number of time frames per parameter

tau_min = X(2,2);
tau_max = X(Nframes,2);
tau_step = X(3,2)-X(2,2);
tau_plot = (tau_min:tau_step:tau_max)';

% Preallocates arrays for faster computing
params = zeros([Nparams 1]); 					% Array for parameter values
dr = zeros(Nframes-1,Nframes-1,Nparticles);
MSD = zeros(Nframes-1,Nparticles);
EN = cell(Nparams,1);

%% MSD Calculation
% For each parameter
for o=1:Nparams
    % For each particle
    for p=1:Nparticles
        % For each time lag
        for tau=1:(Nframes-1)
            m = Nframes - tau;
            e = (o-1)*Nframes; % offset for different parameters
            % For each displacement
            for i=1:m
                dr(tau,i,p)=(X(e+i+tau,p+2)-X(e+i,p+2))^2+(Y(e+i+tau,p+2)-Y(e+i,p+2))^2;
            end
            % Create average for all displacements at a given time
            MSD(tau,p) = sum(dr(tau,:,p))/m;
        end
    end
    EN{o} = mean(MSD,2)';
    EN_std{o} = std(MSD,0,2)';
    params(o) = X(o*Nframes,1);
    
    % Updates the progress bar
    progressbar.Value = .2 + (.5*(o/Nparams));
    progressbar.Message = strcat('Processing data (parameter',{' '},num2str(o),' out of  ',{' '},num2str(Nparams),')');
end

%% Results - data plots
progressbar.Message = 'Plotting data';

% Plotting data - each parameter is displayed as a different curve

% Normal plot
figure('Name','Normal plot');
for z=1:Nparams
    plot(tau_plot,EN{z},'DisplayName',num2str(params(z)));
    xlim([tau_min tau_max]);
    xlabel('\it\tau\rm (s)');
    ylabel('<\Delta\itr\rm^2> (m^2)');
    if z == 1
        hold on;
    end
end

% Logarithmic plot (log x log y)
figure('Name','Log plot');
for z=1:Nparams
    plot(tau_plot,EN{z},'DisplayName',num2str(params(z)));
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    xlabel('\it\tau\rm (s)');
    ylabel('<\Delta\itr\rm^2> (m^2)');
    if z == 1
        hold on;
    end
end

%% Saving workspace
progressbar.Message = 'Saving workspace';
progressbar.Value = .9;
close(progressbar);
close(fig);

FileName=['workspace_',datestr(now, 'dd-mm-yyyy_HH-MM-SS')];
save(FileName);
