clc; clear; close all;

% Import the data using readcell to handle mixed data types (both text and numbers)
data = readcell('bangladesh_satellite_weather_data.xlsx', 'Sheet', 'Sheet1', 'Range', 'D2:D3001');

% Define latitude, longitude, and elevation values
gazipur_lat = 23.993; gazipur_lon = 90.3846; gazipur_elev = 49.715;
betbunia_lat = 22.5475; betbunia_lon = 91.9963; betbunia_elev = 47.415;

% Find number of rows
num_rows = size(data, 1);

% Create new columns for Latitude, Longitude, and Elevation
latitude = nan(num_rows, 1);     % Initialize as NaN
longitude = nan(num_rows, 1);
elevation = nan(num_rows, 1);

% Loop through the data and assign values based on the station name
for i = 1:num_rows
    station = data{i}; % Extract actual content from cell

    if strcmp(station, 'Gazipur')
        latitude(i) = gazipur_lat;
        longitude(i) = gazipur_lon;
        elevation(i) = gazipur_elev;
    elseif strcmp(station, 'Betbunia')
        latitude(i) = betbunia_lat;
        longitude(i) = betbunia_lon;
        elevation(i) = betbunia_elev;
    end
end

% Combine the original data with the new columns
updated_data = [data, num2cell(latitude), num2cell(longitude), num2cell(elevation)];

% Write the updated data to a new Excel file (without headers)
output_filename = 'processed_weather_data_1.xlsx';
writecell(updated_data, output_filename);

disp('Data processing complete. New file saved as "processed_weather_data_1.xlsx".');


