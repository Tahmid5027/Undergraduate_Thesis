clc; clear; close all;

% Import the data using readcell to handle mixed data types (both text and numbers)
filename = 'bangladesh_satellite_weather_data.xlsx';
cloud_thickness_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'Y2:Y3001'); % Cloud Thickness [km]
cloud_attenuation_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'AD2:AD3001'); % Cloud Attenuation [dB]

% Convert the cell array to numeric arrays (if the values are numeric)
cloud_thickness = cell2mat(cloud_thickness_data);
cloud_attenuation = cell2mat(cloud_attenuation_data);

% Remove invalid values (NaN, Inf, or Zero Thickness)
valid_idx = isfinite(cloud_thickness) & isfinite(cloud_attenuation) & cloud_thickness > 0;
filtered_thickness = cloud_thickness(valid_idx);
filtered_attenuation = cloud_attenuation(valid_idx);

% Calculate the proportionality constant
k = mean(filtered_attenuation ./ filtered_thickness);

% Adjust Cloud Attenuation values to be strictly proportional to Cloud Thickness
adjusted_attenuation = cloud_thickness * k;

% Combine data into a cell array for writing
final_data = [num2cell(cloud_thickness), num2cell(adjusted_attenuation)];

% Write the final data to a new Excel file
output_filename = 'adjusted_cloud_data.xlsx';
writecell([{"Cloud Thickness [km]", "Adjusted Cloud Attenuation [dB]"}; final_data], output_filename);

disp('Cloud Attenuation values have been adjusted based on proportionality and saved.');
