clc; clear; close all;
%% C-band rain attenuation
R=50;f=4.5;theta=49.715*pi/180;L=35786; %frequency is in GHz for C-band
%R=50;f=11.6;theta=49.715*pi/180;L=35786; %frequency is in GHz for Ku-band

p='vertical';
alu=Rain_Attenuation(R,f,p,theta,L);

p='horizontal';
kochu=Rain_Attenuation(R,f,p,theta,L);

disp(['C-band Rain Attenuation in the Vertical polarization: ', num2str(alu), ' dB']);
disp(['C-band Rain Attenuation in the Horizontal polarization: ', num2str(kochu), ' dB']);
%% Ku-band rain attenuation
p='vertical';
alu=Rain_Attenuation(R,15,p,theta,L);

p='horizontal';
kochu=Rain_Attenuation(R,15,p,theta,L);

disp(['Ku-band Rain Attenuation in the Vertical polarization: ', num2str(alu), ' dB']);
disp(['Ku-band Rain Attenuation in the Horizontal polarization: ', num2str(kochu), ' dB']);


%h=cofficients_for_h_oxygen(4.5,275,1000,5);

%% Atmospheric attenuation for both bands
% Test inputs
frequency = 0:350;           % GHz
Attenuation_oxygen=zeros(1,length(frequency));
Attenuation_waterVapor=zeros(1,length(frequency));
Ts = 298;              % K (15°C)
Ps = 1013.25;             % hPa (Standard pressure)
row_ws = 15;             % g/m³ (Moderate humidity)
p = 800;                  % hPa (Dry air pressure)
e = row_ws*Ts/216.7;                   % hPa (Water vapor pressure)
theta = 49.17;               % Degrees (Elevation angle)

% % Call the Oxygen_Attenuation function using a loop
% %Attenuation = Oxygen_Attenuation(frequency, Ts, Ps, row_ws, p, e, theta);
% for i=1:351
%     Attenuation_oxygen(i) = Oxygen_Attenuation(frequency(i), Ts, Ps, row_ws, p, e, theta);
%     Attenuation_waterVapor(i) = WaterVapor_Attenuation(f,p,e,theta);
% end
% 
% % Display the result
% %disp(['Oxygen Attenuation: ', num2str(Attenuation), ' dB/km']);
% 
% % Plot the result with the y-axis in dB scale
% figure(1)
% semilogy(frequency, Attenuation_oxygen);
% xlabel('Frequency (GHz)');
% ylabel('Oxygen Attenuation (dB)');
% title('Oxygen Attenuation vs Frequency (Log Scale)');
% 
% figure(2)
% semilogy(frequency, Attenuation_waterVapor);
% xlabel('Frequency (GHz)');
% ylabel('Water Vapor Attenuation (dB)');
% title('Water Vapor Attenuation vs Frequency (Log Scale)');

random1=Oxygen_Attenuation(4.5, Ts, Ps, row_ws, p, e, theta);
disp(['C-band Oxygen Attenuation: ', num2str(random1), ' dB']);
random2=WaterVapor_Attenuation(4.5, p, e, theta);
disp(['C-band Water Vapor Attenuation: ', num2str(random2), ' dB']);
C_band_Total_atmospheric_attenuation=random1+random2;
disp(['C-band Atmospheric Attenuation: ', num2str(C_band_Total_atmospheric_attenuation), ' dB']);

random3=Oxygen_Attenuation(15, Ts, Ps, row_ws, p, e, theta);
disp(['Ku-band Oxygen Attenuation: ', num2str(random3), ' dB']);
random4=WaterVapor_Attenuation(15, p, e, theta);
disp(['Ku-band Water Vapor Attenuation: ', num2str(random4), ' dB']);
Ku_band_Total_atmospheric_attenuation=random3+random4;
disp(['Ku-band Atmospheric Attenuation: ', num2str(Ku_band_Total_atmospheric_attenuation), ' dB']);

%% Cloud attenuation for both bands

% f=4.5, T=298K, row=0.04, H=0.75km
Cloud_attenuation_C_band= Cloud_Attenuation(4.5,298,0.04,0.75,theta);
Cloud_attenuation_Ku_band= Cloud_Attenuation(15,298,0.04,0.75,theta);

disp(['C-band Cloud Attenuation: ', num2str(Cloud_attenuation_C_band), ' dB']);
disp(['Ku-band Cloud Attenuation: ', num2str(Cloud_attenuation_Ku_band), ' dB']);



%% Total Attenuation Calculation

Total_attenuation_C_band=FSPL(4.5,35786)+Rain_Attenuation(12,4.5,'vertical',theta*pi/180,35786)+Oxygen_Attenuation(4.5,Ts,Ps,row_ws,p,e,theta)+WaterVapor_Attenuation(4.5,p,e,theta)+Cloud_Attenuation(4.5,298,0.04,0.75,theta);
Total_attenuation_Ku_band=FSPL(15,35786)+Rain_Attenuation(12,15,'vertical',theta*pi/180,35786)+Oxygen_Attenuation(15,Ts,Ps,row_ws,p,e,theta)+WaterVapor_Attenuation(15,p,e,theta)+Cloud_Attenuation(15,298,0.04,0.75,theta);

disp(['C-band Total Attenuation: ', num2str(Total_attenuation_C_band), ' dB']);
disp(['Ku-band Total Attenuation: ', num2str(Total_attenuation_Ku_band), ' dB']);


