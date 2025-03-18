clc; clear; close all;

% Load the dataset using readcell to handle mixed data types
filename = 'bangladesh_satellite_weather_data.xlsx';

% Read the required columns from the Excel file
surface_temp_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'V2:V3001'); % Surface Temperature [°C]
pressure_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'W2:W3001'); % Total Barometric Pressure [hPa]
humidity_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'X2:X3001'); % Humidity Level [%]
atmospheric_attenuation_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AB2:AB3001'); % Atmospheric Attenuation [dB]

% Convert cell arrays to numeric arrays
surface_temp = cell2mat(surface_temp_data);
pressure = cell2mat(pressure_data);
humidity = cell2mat(humidity_data);
atmospheric_attenuation = cell2mat(atmospheric_attenuation_data);

% Remove invalid values (NaN, Inf, or missing data)
valid_idx = isfinite(surface_temp) & isfinite(pressure) & isfinite(humidity) & isfinite(atmospheric_attenuation);

% Extract valid values
filtered_surface_temp = surface_temp(valid_idx);
filtered_pressure = pressure(valid_idx);
filtered_humidity = humidity(valid_idx);
filtered_attenuation = atmospheric_attenuation(valid_idx);

% Compute a combined ranking score for correlation (using mean ranking)
[~, rank_temp] = sort(filtered_surface_temp);
[~, rank_pressure] = sort(filtered_pressure);
[~, rank_humidity] = sort(filtered_humidity);

% Compute average rank of each row to create a single correlation metric
combined_rank = (rank_temp + rank_pressure + rank_humidity) / 3;

% Get the order for sorting attenuation based on the combined rank
[~, sorted_indices] = sort(combined_rank);

% Sort the attenuation values in ascending order
sorted_attenuation = sort(filtered_attenuation);

% Assign the sorted attenuation values based on the computed ranking
adjusted_attenuation = zeros(size(filtered_attenuation));
adjusted_attenuation(sorted_indices) = sorted_attenuation;

% Store the final correlated values
final_data = [num2cell(filtered_surface_temp), num2cell(filtered_pressure), ...
              num2cell(filtered_humidity), num2cell(adjusted_attenuation)];

% Save the modified dataset to a new Excel file
output_filename = 'correlated_atmospheric_attenuation.xlsx';
writecell([{"Surface Temperature [°C]", "Total (Barometric) Surface Pressure [hPa]", ...
            "Humidity Level [%]", "Correlated Atmospheric Attenuation [dB]"}; final_data], output_filename);

% Display message
disp('Atmospheric Attenuation values have been reordered to correlate with Surface Temperature, Pressure, and Humidity.');
