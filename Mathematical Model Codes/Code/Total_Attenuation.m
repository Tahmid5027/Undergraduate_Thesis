clc; clear all; close all;

%% Rain Attenuation

% Import the data from the Excel file
filename = 'bangladesh_satellite_weather_data.xlsx';

% Read Rain Rate (R), Frequency (f), Elevation Angle (θ), and Satellite Distance (L)
rain_rate_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'U2:U3001'); % Rain Rate [mm/hour]
frequency_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'I2:I3001'); % Frequency [GHz]
theta_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'J2:J3001'); % Elevation Angle [degrees]
distance_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'K2:K3001'); % Satellite Distance [km]
polarization_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'M2:M3001'); % Polarization (Vertical/Horizontal)
temp = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'V2:V3001'); % surface temperature
presssure= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'W2:W3001'); % surface pressure
humid= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'X2:X3001'); % humidity level
water_temp_cloud=readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AA2:AA3001'); % Liquid water temperature in clouds/fog
water_dens_cloud=readcell(filename, 'Sheet', 'Sheet1', 'Range', 'Z2:Z3001'); % Liquid water density in clouds/fog
tot_atten= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AF2:AF3001'); % Total attenuation
atm_atten= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AB2:AB3001');
rain_atten= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AC2:AC3001');
cloud_atten= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AD2:AD3001');
fspl_atten= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AE2:AE3001');
mash= readcell(filename, 'Sheet', 'Sheet1', 'Range', 'B2:B3001'); % Months

% Convert cell arrays to numeric arrays
rain_rate = cell2mat(rain_rate_data);
frequency = cell2mat(frequency_data);
theta = cell2mat(theta_data) * pi/180; % Convert degrees to radians
distance = cell2mat(distance_data);
temp_surface=cell2mat(temp);
pressure_surface=cell2mat(presssure);
humidity=cell2mat(humid);
water_temp_clouds=cell2mat(water_temp_cloud);
water_density_clouds=cell2mat(water_dens_cloud);
Actual_total_attenuation=cell2mat(tot_atten);
atmp_attenuation=cell2mat(atm_atten);
rain_attenuation=cell2mat(rain_atten);
cloud_attenuation=cell2mat(cloud_atten);
fspl_attenuation=cell2mat(fspl_atten);
month=cell2mat(mash);


% Initialize arrays for attenuation results
vertical_attenuation = zeros(size(rain_rate));
horizontal_attenuation = zeros(size(rain_rate));

% Compute attenuation for each dataset
for i = 1:length(rain_rate)
    R = rain_rate(i);
    f = frequency(i);
    theta_i = theta(i)*pi/180;
    L = distance(i);
    
    % Check polarization type and compute attenuation
    if strcmpi(polarization_data{i}, 'Vertical')
        vertical_attenuation(i) = Rain_Attenuation(R, f, 'Vertical', theta_i, L);
    else
        horizontal_attenuation(i) = Rain_Attenuation(R, f, 'Horizontal', theta_i, L);
    end
end

Attenuation_rain = vertical_attenuation + horizontal_attenuation;

%% Calculating some other factors

% Saturated water vapor pressure
F_sat = Goff_Gratch(temp_surface);

% Surface water density (Absolute humidity)
row= (0.018/8.314)*(pressure_surface./(temp_surface+273));

% Water vapor pressure
pressure_water= 0.01*(F_sat.*humidity);

% Dry air pressure
pressure_air= pressure_surface - pressure_water;

%% Atmospheric Attenuation

% Preallocate output arrays
Attenuation_oxygen = zeros(3000, 1);
Attenuation_water_vapor = zeros(3000, 1);

% Compute Attenuation for each value from i = 1 to i = 3000
for i = 1:3000
    Attenuation_oxygen(i) = Oxygen_Attenuation(frequency(i), temp_surface(i), pressure_surface(i), row(i), pressure_air(i), pressure_water(i), theta(i));
    Attenuation_water_vapor(i) = WaterVapor_Attenuation(frequency(i), pressure_air(i), pressure_water(i), theta(i));
end

Attenuation_atmospheric= abs(Attenuation_water_vapor + Attenuation_oxygen);

%% Cloud attenuation

Attenuation_cloud = zeros(3000, 1);
Cloud_base_height = zeros(3000,1);

for i=1:3000
    Cloud_base_height(i)=getCloudBaseHeight(month(i));
end

% Compute Cloud Attenuation for each value from i = 1 to i = 3000
for i = 1:3000
    Attenuation_cloud(i) = Cloud_Attenuation(frequency(i), water_temp_clouds(i), water_density_clouds(i), Cloud_base_height(i), theta(i));
end

%% Free space path loss

Attenuation_fspl=FSPL(frequency,35786);

%% Total Path loss

Attenuation_total= Attenuation_fspl + Attenuation_cloud + Attenuation_rain + Attenuation_atmospheric;

%% Accuracy of the model

% Calculate Mean Absolute Percentage Error (MAPE)
MAPE = mean(abs((Attenuation_total - Actual_total_attenuation) ./ Actual_total_attenuation) * 100);

% Calculate Accuracy (100 - MAPE)
Accuracy = 100 - MAPE;

% Calculate Mean Squared Error (MSE)
MSE = mean((Attenuation_total - Actual_total_attenuation).^2);

% Display Accuracy
disp(['Model Accuracy: ', num2str(Accuracy), '%']);
disp(['Mean Squared Error (MSE): ', num2str(MSE)]);

%% Generating the comparative Excel file
% Calculate Relative Error Rate (in percentage)
relative_error_rate = abs((Attenuation_total - Actual_total_attenuation) ./ Actual_total_attenuation) * 100;

% Calculate Relative Accuracy Rate (for each data point)
relative_accuracy_rate = 100 - relative_error_rate;

% Create a table with the required data
data_table = table(Actual_total_attenuation, Attenuation_total, relative_error_rate, relative_accuracy_rate);

% % Add Mean Accuracy Rate to the table (the same value for all rows)
% data_table.Mean_Accuracy_rate = Accuracy_rate * ones(height(data_table), 1);

% Define the filename for the Excel file
filename = 'total_attenuation_accuracy_data.xlsx';

% Write the table to the Excel file
writetable(data_table, filename);

% Display a message indicating the file has been created
disp(['Data has been written to ', filename]);

%% Plot (Total Attenuation)
% Plot Total Attenuation vs. Actual Total Attenuation
figure;
plot(Actual_total_attenuation, Attenuation_total, 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Blue circles
hold on;
plot(Actual_total_attenuation, Actual_total_attenuation, 'r-', 'LineWidth', 1.5); % Red line (ideal case)
hold off;

% Labels and Title
xlabel('Actual Total Attenuation (dB)');
ylabel('Computed Total Attenuation (dB)');
title('Comparison of Computed vs. Actual Total Attenuation');
legend('Computed Attenuation', 'Ideal 1:1 Line', 'Location', 'Best');
grid on;

% Improve appearance
set(gca, 'FontSize', 12); % Set axis font size
axis equal; % Make scales equal for better comparison

%% Plot (Atmospheric Attenuation)
% Plot atmospheric Attenuation vs. Actual atmospheric Attenuation
figure;
plot(atmp_attenuation, Attenuation_atmospheric, 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Blue circles
hold on;
plot(atmp_attenuation, atmp_attenuation, 'r-', 'LineWidth', 1.5); % Red line (ideal case)
hold off;

% Labels and Title
xlabel('Actual Atmospheric Attenuation (dB)');
ylabel('Computed Atmospheric Attenuation (dB)');
title('Comparison of Computed vs. Actual Atmospheric Attenuation');
legend('Computed Attenuation', 'Ideal 1:1 Line', 'Location', 'Best');
grid on;

% Improve appearance
set(gca, 'FontSize', 12); % Set axis font size
axis equal; % Make scales equal for better comparison

%% Plot (Rain Attenuation)
% Plot atmospheric Attenuation vs. Actual atmospheric Attenuation
figure;
plot(rain_attenuation, Attenuation_rain, 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Blue circles
hold on;
plot(rain_attenuation, rain_attenuation, 'r-', 'LineWidth', 1.5); % Red line (ideal case)
hold off;

% Labels and Title
xlabel('Actual Rain Attenuation (dB)');
ylabel('Computed Rain Attenuation (dB)');
title('Comparison of Computed vs. Actual Rain Attenuation');
legend('Computed Attenuation', 'Ideal 1:1 Line', 'Location', 'Best');
grid on;

% Improve appearance
set(gca, 'FontSize', 12); % Set axis font size
axis equal; % Make scales equal for better comparison

%% Plot (Cloud Attenuation)
% Plot atmospheric Attenuation vs. Actual atmospheric Attenuation
figure;
plot(cloud_attenuation, Attenuation_cloud, 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Blue circles
hold on;
plot(cloud_attenuation, cloud_attenuation, 'r-', 'LineWidth', 1.5); % Red line (ideal case)
hold off;

% Labels and Title
xlabel('Actual Cloud Attenuation (dB)');
ylabel('Computed Cloud Attenuation (dB)');
title('Comparison of Computed vs. Actual Cloud Attenuation');
legend('Computed Attenuation', 'Ideal 1:1 Line', 'Location', 'Best');
grid on;

% Improve appearance
set(gca, 'FontSize', 12); % Set axis font size
axis equal; % Make scales equal for better comparison

%% Plot (Free Space Attenuation)
% Plot atmospheric Attenuation vs. Actual atmospheric Attenuation
figure;
plot(fspl_attenuation, Attenuation_fspl, 'bo', 'MarkerSize', 5, 'LineWidth', 1.5); % Blue circles
hold on;
plot(fspl_attenuation, fspl_attenuation, 'r-', 'LineWidth', 1.5); % Red line (ideal case)
hold off;

% Labels and Title
xlabel('Actual Free Space Attenuation (dB)');
ylabel('Computed Free Space Attenuation (dB)');
title('Comparison of Computed vs. Actual Free Space Attenuation');
legend('Computed Attenuation', 'Ideal 1:1 Line', 'Location', 'Best');
grid on;

% Improve appearance
set(gca, 'FontSize', 12); % Set axis font size
axis equal; % Make scales equal for better comparison





