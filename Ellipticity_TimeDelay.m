clc; clear; close all;

path = 'results/';
pathData = 'data/';

dataFiles = dir(fullfile(path, '*.txt'));
dataFiles = natsortfiles(dataFiles);

for i = 1:1
    dataName = dataFiles(i).name;
    dash_index = strfind(dataName, '_');
    dot_index = strfind(dataName, '.');

    time_delay = dataName(dash_index(2)+1:dot_index - 1);
    
    data = readmatrix(fullfile(path, dataName));
    disp(['Calculating Stuff for: ' dataName])
    t = data(:,1);
    Sx = data(:,2);
    Sy = data(:,3);
    
    delta_t = mean(diff(t));    % Time interval between samples
    Fs = 2*pi / delta_t;        % Sampling frequency
    
    % Compute Fourier Transform
    SX = fft(Sx);
    SY = fft(Sy);
    f = (0:length(t)-1) * (Fs/length(t));   % Frequency vector
    f = f/0.057;                            % Omega/omega
    
    % Calculate Ellipticity
    phi_x = angle(SX);
    phi_y = angle(SY);
    rho = abs(sqrt(SY./SX));
    epsilon = -tan(0.5*asin((2*rho./(1 + rho.^2)).*sin(phi_y - phi_x)));
    sigma = 0.125;
    N = 1:35;

    S = sqrt(SX.^2 + SY.^2);
    epsilon_weighted = zeros(size(N));

    for k = N
        weighting = exp(-0.5 * ((f - k).^2) / sigma^2);
        epsilon_weighted(k) = sum(epsilon .*((abs(S)).^2).* weighting) / sum(((abs(S)).^2) .* weighting);
    end

    save(fullfile(pathData, [dataName(1:dot_index - 1), '.mat']), "t", "SX", "SY", "epsilon_weighted", "f", "N");
    clear t Sx Sy SX SY f rho epsilon epsilon_weighted;
end


