clc; clear; close all;

% Import the data using readcell to handle mixed data types (both text and numbers)
data = readcell('Satellite_Ground_Station_Path_Loss_Data.xlsx', 'Sheet', 'Sheet1', 'Range', 'A2:AB2501');

% Loop through each column to check for text data and convert to integer codes
for col = 1:size(data, 2)
    % Check if the column contains strings (categorical data)
    if all(cellfun(@ischar, data(:, col)))
        % Convert column with strings to categorical integers
        data(:, col) = num2cell(double(categorical(data(:, col))) - 1);  % Convert to integers and store as cells
    end
end

% Convert the entire cell array back to a numeric matrix, inserting NaN for non-numeric cells
X = cellfun(@(x) double(x), data, 'UniformOutput', false);
X = cell2mat(X);

% for col = 1:27
%     figure;
%     plot(X(:, col), X(:, 28), 'o'); % Scatter plot each column vs the 28th column
%     xlabel(['Column ', num2str(col)]);
%     ylabel('Path Loss');
%     title(['Path Loss vs Column ', num2str(col)]);
% end     

labels={'Longitude', 'Latitude', 'Elevation', 'Transmitter Height', 'Antenna Gain', 'Transmitter Power','Frequency Band', 'Polarization Type', 'Environment Type', 'Weather Conditions', 'Humidity Levels','Temperature', 'Atmospheric Pressure', 'Season', 'Clutter Height', 'Line of Sight','Satellite Altitude', 'Satellite Position Latitude', 'Satellite Position Longitude','Downlink Frequency', 'Satellite Antenna Gain', 'Beam Type', 'Polarization Match','Space Weather Conditions', 'Power Settings', 'Transmission Mode', 'Path Length', 'Path Loss'};

% Create a table with the processed data
dataTable = array2table(X, 'VariableNames', labels);

% Specify the name of the output Excel file
outputFileName = 'Processed_Satellite_Data.xlsx';

% Write the table to an Excel file
writetable(dataTable, outputFileName);
