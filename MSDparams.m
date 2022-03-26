clear
clc

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
X = table2array(readtable(fullfile('D:\Kolacek\MSD_eval\x_param.csv')));
Y = table2array(readtable(fullfile('D:\Kolacek\MSD_eval\y_param.csv')));

% Getting some info about the data for processing
progressbar.Value = .2; 
progressbar.Message = 'Processing data';

Nparticles = size(X,2)-2; % Number of particles equals number of columns - 2 (parameter and time column)
params = unique(X(:,1)); % Array of parameter values
Nparams = size(params,1); % Number of different parameters
Nframes = (size(X,1)/Nparams); % Number of time frames per parameter

% Sets the time_step array for plot
time_step = (0:0.0001:0.001-0.0001)';

% Preallocates arrays for faster computing
Deltar = zeros(Nframes-1,Nframes-1,Nparticles);
MSD = zeros(Nframes-1,Nparticles);
EN = cell(Nparams,1);

%% MSD Calculation
% For each parameter
for a=1:Nparams
    for b=1:Nparticles
        for c=1:(Nframes-1)
            d=Nframes-c;
            e=(a-1)*Nframes; % offset for different parameters
            for i=1:d
                Deltar(c,i,b)=(X(e+i+c,b+2)-X(e+i,b+2))^2+(Y(e+i+c,b+2)-Y(e+i,b+2))^2;
            end
            MSD(c,b)=sum(Deltar(c,:,b))/d;
        end
    end
    EN{a} = mean(MSD,2)';
    
    progressbar.Value = .2 + (.5*(a/Nparams));
    progressbar.Message = strcat('Processing data (parameter',{' '},num2str(a),' out of  ',{' '},num2str(Nparams),')');
end

%% Results - data plots
progressbar.Message = 'Plotting data';

% Plotting data - each parameter is displayed as a different curve

% Normal plot
figure('Name','Normal plot');
for z=1:Nparams
    plot(time_step,EN{z},'DisplayName',num2str(params(z)));
    if z == 1
        hold on;
    end
end

% Logarithmic plot (log x log y)
figure('Name','Log plot');
for z=1:Nparams
    loglog(time_step,EN{z},'DisplayName',num2str(params(z)));
    if z == 1
        hold on;
    end
end

%% Saving workspace
progressbar.Message = 'Saving workspace';
progressbar.Value = .9;

FileName=['workspace_',datestr(now, 'dd-mm-yyyy_HH-MM-SS')];
save(FileName);

%% Unload app
close(progressbar);
close(fig);

%load 'MSD.mat' if you want to use the values