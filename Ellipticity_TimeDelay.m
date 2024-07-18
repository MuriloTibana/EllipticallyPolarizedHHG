clc; clear; close all;

path = 'results/';
dataFiles = dir(fullfile(path, '*.txt'));
dataFiles = natsortfiles(dataFiles);

for i = 1:1
    dataName = dataFiles(i).name;
    dash_index = strfind(dataName, '_');
    dot_index = strfind(dataName, '.');
    time_delay = dataName(dash_index(2)+1:dot_index - 1);
    
    data = readmatrix(fullfile(path, dataName));
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
    phi_x = 0;
    phi_y = -pi/4;
    rho = abs(SY./SX);
    epsilon = -tan(0.5*asin((2*rho./(1 + rho.^2))*sin(phi_y - phi_x)));
    sigma = 0.125;
    N = 1:35;

    S = sqrt(SX.^2 + SY.^2);
    epsilon_weighted = zeros(size(N));

    for k = N
        weighting = exp(-0.5 * ((f - k).^2) / sigma^2);
        
        epsilon_weighted(k) = sum(epsilon .*((abs(S)).^2).* weighting) / sum(((abs(S)).^2) .* weighting);
    end

    % Plot the high harmonics spectrum
    figure(i);
    plot(f, abs(SX), f, abs(SY), 'LineWidth', 1);
    xlabel('Harmonic Order (multiples of $\omega$)', 'Interpreter','latex');
    ylabel('Componnent of HHG', 'Interpreter','latex');
    legend('|S_x|^2', '|S_y|^2')
    title(['High Harmonics Spectrum - Time Delay: ' time_delay]);
    yscale log
    xlim([0 36])
end


