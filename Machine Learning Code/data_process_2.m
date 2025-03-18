clc; clear; close all;

% Import the data using readcell to handle mixed data types (both text and numbers)
data = readcell('bangladesh_satellite_weather_data.xlsx', 'Sheet', 'Sheet1', 'Range', 'I2:I3001');

% Convert the cell array to a numeric array (if the values are numeric)
numeric_data = cell2mat(data);  % Ensure 'data' only contains numbers

% Initialize a cell array for the band classification
bands = cell(size(numeric_data)); % Same size as the data
repeater_gain = cell(size(numeric_data));
antenna_gain = cell(size(numeric_data));
transmitter_power = cell(size(numeric_data));

% Loop through the numeric data and classify into "C-band" or "Ku-band"
for i = 1:length(numeric_data)
    if numeric_data(i) >= 4.4 && numeric_data(i) <= 5
        bands{i} = 'C-band';
        repeater_gain{i} = 111.20;
        antenna_gain{i} = 54.4;
        transmitter_power{i} = 2200;
    elseif numeric_data(i) >= 10.5 && numeric_data(i) <= 13
        bands{i} = 'Ku-band';
        repeater_gain{i} = 125.40;
        antenna_gain{i} = 61.2;
        transmitter_power{i} = 1250;
    else
        bands{i} = 'Unknown'; % Assign "Unknown" for values outside the ranges
        repeater_gain{i} = 0;
        antenna_gain{i} = 0;
        transmitter_power{i} = 0;
    end
end

% Combine all the data into one cell array
final_data = [num2cell(numeric_data), bands, repeater_gain, antenna_gain, transmitter_power];

% Write the final data to a new Excel file
output_filename = 'processed_weather_data_2.xlsx';
writecell(final_data, output_filename);

disp('Band classification and parameter assignment complete. New file saved as "band_classification_with_parameters.xlsx".');
