% MSDsimple.m
clear 
clc

% User-defined variables
DataPath = "D:\MSD";

%% Script initialization
% Creates progress bar for a better overview of the script's progress
fig = uifigure;
progressbar = uiprogressdlg(fig,'Title','COMSOL study',...
        'Message','Opening the application');

%% Variable initialization and memory pre-allocation
% Loading data from the specified directory
progressbar.Value = 0.1; 
progressbar.Message = 'Loading data';

% Load first file for memory pre-allocation
X = table2array(readtable(fullfile(DataPath,'x_1.csv'),'ReadVariableNames',false,'HeaderLines', 5));

Nsets = (length(dir(fullfile(DataPath,'*.csv')))/2); 	% Number of sets (Number of all csv files in the directory divided by 2)
Nparticles = size(X,2)-1; 				% Since the file contains one column with time information, one is subtracted 
Nframes = length(X(:,1)); 				% Reads the number of frames (rows)

tau_min = X(2,1);
tau_max = X(Nframes,1);
tau_step = X(3,1)-X(2,1);
tau_plot = (tau_min:tau_step:tau_max)';

% Preallocates arrays for faster computing
dr = zeros(Nframes-1,Nframes-1,Nparticles);
MSD = zeros(Nframes-1,Nparticles);
EN = cell(Nsets,1);

progressbar.Value = .2;
%% MSD Calculation
% For each set of data
for o=1:Nsets
    % Updates the progress bar
    progressbar.Value = .2 + (.5*(o/Nsets));
    progressbar.Message = strcat('Processing data (Set',{' '},num2str(o),' out of  ',{' '},num2str(Nsets),')');
    
    % Reads the data from the target directory
    X = table2array(readtable(fullfile(DataPath,strcat('x_',num2str(o),'.csv')),'ReadVariableNames',false,'HeaderLines', 5));
    Y = table2array(readtable(fullfile(DataPath,strcat('y_',num2str(o),'.csv')),'ReadVariableNames',false,'HeaderLines', 5));
    
    % For each particle
    for p = 1:Nparticles
        % For each time lag
        for tau = 1:(Nframes-1)
            m = Nframes - tau;
            % For each displacement
            for i = 1:m
                dr(tau,i,p) = ((X(i+tau,p+1)-X(i,p+1))^2 + (Y(i+tau,p+1)-Y(i,p+1))^2);
            end    
            % Create average for all displacements at a given time
            MSD(tau,p) = sum(dr(tau,:,p))/m;
        end
    end
    % Creates ensemble average from all particles (rows)
    EN{o} = mean(MSD,2)';
    EN_std{o} = std(MSD,0,2)';
end

%% Results - data plots
progressbar.Message = 'Plotting data';

% Plotting data - each parameter is displayed as a different curve

% Normal plot
figure('Name','Normal plot');
for z=1:Nsets
    %scatter(tau_plot,EN{z},'x');
    plot(tau_plot,EN{z});
    xlim([tau_min tau_max]);
    xlabel('\it\tau\rm (s)');
    ylabel('<\Delta\itr\rm^2> (m^2)');
    if z == 1
        hold on;
    end
end

% Logarithmic plot (log x log y)
figure('Name','Log plot');
for z=1:Nsets
    %scatter(tau_plot,EN{z},'x');
    plot(tau_plot,EN{z});
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
