function cloud_base_height = getCloudBaseHeight(month)
    % Function to estimate cloud base height (in meters) based on the month in Bangladesh
    % The height is randomly picked within the expected range for each month.

    switch month
        case 1
            cloud_base_height = 0.001*randi([1500, 3000]); % High
        case 2
            cloud_base_height = 0.001*randi([1500, 3000]); % High
        case 3
            cloud_base_height = 0.001*randi([1000, 2500]); % Moderate
        case 4
            cloud_base_height = 0.001*randi([800, 2000]);  % Moderate
        case 5
            cloud_base_height = 0.001*randi([800, 2000]);  % Moderate
        case 6
            cloud_base_height = 0.001*randi([500, 1500]);  % Low
        case 7
            cloud_base_height = 0.001*randi([300, 1200]);  % Very Low
        case 8
            cloud_base_height = 0.001*randi([300, 1200]);  % Very Low
        case 9
            cloud_base_height = 0.001*randi([500, 1500]);  % Low to Moderate
        case 10
            cloud_base_height = 0.001*randi([1000, 2500]); % Moderate
        case 11
            cloud_base_height = 0.001*randi([1500, 3000]); % High
        case 12
            cloud_base_height = 0.001*randi([1500, 3000]); % High
        otherwise
            error('Invalid month! Please enter a valid month name.');
    end
    cloud_base_height=0.001*cloud_base_height;
    % Display the result
    %fprintf('Estimated cloud base height for %s: %d meters\n', month, cloud_base_height);
end
