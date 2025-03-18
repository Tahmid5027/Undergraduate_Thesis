clc; clear all; close all;
% Load the dataset using readcell to handle mixed data types
filename = 'bangladesh_satellite_weather_data.xlsx';

% Read the first column (dates)
date_data = readcell(filename, 'Sheet', 'Sheet1', 'Range', 'A2:A3001');

% Initialize an empty cell array for cleaned dates
cleaned_dates = cell(size(date_data));

% Process each cell in the date column
for i = 1:length(date_data)
    if isnumeric(date_data{i}) % If it's a numeric value (Excel serial date)
        cleaned_dates{i} = datestr(date_data{i}, 'yyyy-mm-dd'); % Convert to string format
    elseif ischar(date_data{i}) && ~all(isspace(date_data{i})) % If it's a non-empty string
        cleaned_dates{i} = date_data{i}; % Keep it as is
    else
        cleaned_dates{i} = ''; % Handle missing or empty values
    end
end

% Remove empty values before conversion to datetime
valid_dates = cleaned_dates(~cellfun(@isempty, cleaned_dates)); % Remove empty entries

% Convert cleaned cell array to datetime
date_data_dt = datetime(valid_dates, 'InputFormat', 'yyyy-MM-dd', 'Format', 'yyyy-MM-dd');

% Subtract 4 years
corrected_dates = date_data_dt - calyears(4);

% Write the corrected dates back to the Excel file
writematrix(corrected_dates, filename, 'Sheet', 'Sheet1', 'Range', 'A2');

disp('Dates corrected and saved successfully.');
