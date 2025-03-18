clc; clear; close all;

% Constants
c = 3.0e8; % Speed of light in m/s
d = 35786e3; % Distance in meters (converted from km)

% Load the dataset using readcell to handle mixed data types
filename = 'bangladesh_satellite_weather_data.xlsx';

% Read the required columns from the Excel file
uplink_freq_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'I2:I3001'); % Uplink Frequency [GHz]

% Convert cell array to numeric and convert GHz to Hz
uplink_freq = cell2mat(uplink_freq_data) * 1e9; % Convert GHz to Hz

% Remove invalid values (NaN, Inf, or missing data)
valid_idx = isfinite(uplink_freq);

% Extract valid values
filtered_uplink_freq = uplink_freq(valid_idx);

% Compute FSPL using the corrected formula
fspl_calculated = 20 * log10((4 * pi * d * filtered_uplink_freq) / c);

% Introduce a small random deviation using randn
deviation_scale = 2; % Scale factor for deviation (5% variation)
random_deviation = deviation_scale * randn(size(filtered_uplink_freq)); % Normal random deviation
adjusted_fsp_loss = fspl_calculated + abs(random_deviation); % Apply deviation

% Store the final computed FSPL values
final_data = [num2cell(filtered_uplink_freq / 1e9), num2cell(adjusted_fsp_loss)]; % Convert frequency back to GHz

% Save the modified dataset to a new Excel file
output_filename = 'corrrelated_FSPL.xlsx';
writecell([{"Uplink Frequency [GHz]", "Generated Free Space Path Loss [dB]"}; final_data], output_filename);

% Display message
disp('Free Space Path Loss values have been computed using the corrected formula with random deviation and saved.');
