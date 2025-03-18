clc; clear; close all;

% Import the data using readcell to handle mixed data types (both text and numbers)
filename = 'bangladesh_satellite_weather_data.xlsx';
rain_rate_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'U2:U3001'); % Rain Rate [mm/hour]
rain_attenuation_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AC2:AC3001'); % Rain Attenuation [dB]

% Convert the cell array to numeric arrays
rain_rate = cell2mat(rain_rate_data);
rain_attenuation = cell2mat(rain_attenuation_data);

% Remove invalid values (NaN, Inf, or Zero Rain Rate)
valid_idx = isfinite(rain_rate) & isfinite(rain_attenuation) & rain_rate > 0;
filtered_rain_rate = rain_rate(valid_idx);
filtered_rain_attenuation = rain_attenuation(valid_idx);

% Sort only the rain attenuation values in ascending order
sorted_rain_attenuation = sort(filtered_rain_attenuation);

% Assign the sorted rain attenuation values **without changing the order of rain rate**
adjusted_rain_attenuation = zeros(size(filtered_rain_attenuation)); % Placeholder array

% Get ranking order of rain rate values (without sorting)
[~, rankIdx] = sort(filtered_rain_rate); % Get ranking positions
[~, originalOrder] = sort(rankIdx); % Get back to original order

% Assign sorted rain attenuation values according to rank positions
adjusted_rain_attenuation = sorted_rain_attenuation(originalOrder);

% Combine data into a cell array for writing
final_data = [num2cell(filtered_rain_rate), num2cell(adjusted_rain_attenuation)];

% Write the final data to a new Excel file
output_filename = 'correlated_rain_data.xlsx';
writecell([{"Rain Rate [mm/hour]", "Correlated Rain Attenuation [dB]"}; final_data], output_filename);

disp('Rain Attenuation values have been adjusted to correlate with Rain Rate without changing its order.');
