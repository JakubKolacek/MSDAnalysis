clear 
clc

% User-defined variables
DataPath = "C:\COMSOL\MSD";

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

NSets = (length(dir(fullfile(DataPath,'*.csv')))/2); % Number of sets (Number of all csv files in the directory divided by 2)
Nparticles = size(X,2)-1; % Since the file contains one column with time information, one is subtracted 
Nframes = length(X(:,1)); % Reads the number of frames (rows)

time_step = (0:X(3,1)-X(2,1):X(Nframes,1))';

% Preallocates arrays for faster computing
Deltar = zeros(Nframes-1,Nframes-1,Nparticles);
MSD = zeros(Nframes-1,Nparticles);
EN = cell(NSets,1);

progressbar.Value = .2;
%% MSD Calculation
% For each set of data
for o=1:NSets
    progressbar.Value = .2 + (.5*(o/NSets));
    progressbar.Message = strcat('Processing data (Set',{' '},num2str(o),' out of  ',{' '},num2str(NSets),')');
    
    % Clears the previous data from arrays
    X = zeros;
    Y = zeros;
    
    % Reads the data from the target directory
    X = table2array(readtable(fullfile(DataPath,strcat('x_',num2str(o),'.csv')),'ReadVariableNames',false,'HeaderLines', 5));
    Y = table2array(readtable(fullfile(DataPath,strcat('y_',num2str(o),'.csv')),'ReadVariableNames',false,'HeaderLines', 5));
    
    % For each particle
    for p=1:Nparticles
        % For each time step
        for n= 1:(Nframes-1)
            m=Nframes-n;
            % For each time difference
            for i=1:m
                Deltar(n,i,p)=(X(i+n,p+1)-X(i,p+1))^2+(Y(i+n,p+1)-Y(i,p+1))^2;
            end
            % Create average for all displacements at a given time
            MSD(1,p) = 0;
            MSD(n+1,p) = sum(Deltar(n,:,p))/m;
        end
    end
    % Creates ensemble average from all particles (rows)
    EN{o} = mean(MSD,2)';
end

%% Results - data plots
progressbar.Message = 'Plotting data';

% Plotting data - each parameter is displayed as a different curve

% Normal plot
figure('Name','Normal plot');
for z=1:NSets
    plot(time_step,EN{z});
    if z == 1
        hold on;
    end
end

% Logarithmic plot (log x log y)
figure('Name','Log plot');
for z=1:NSets
    loglog(time_step,EN{z});
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

%load 'MSD.mat' if you want to use the values 