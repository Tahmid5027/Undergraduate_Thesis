function saturated_vapor_pressure= Goff_Gratch(T)
% MATLAB Code for Goff-Gratch Saturation Pressure Calculation

% Input: Temperature in Kelvin
%T = 298; % Example: 298 K
T=T+273;

% Constants
T0 = 373.16; % Reference temperature in Kelvin
%log10_e = log10(exp(1)); % Convert natural log to base-10 log

% Goff-Gratch Equation
ln_ps = -7.90298 * (T0 ./ T - 1) + ...
        5.02808 * log10(T0 ./ T) + ...
        -1.3816e-7 * (10.^(11.344 * (1 - T ./ T0)) - 1) + ...
        8.1328e-3 * (10.^(-3.49149 * (T0 ./ T - 1)) - 1) + ...
        log10(1013.246); % Standard pressure in hPa

% Convert to Pa
ps_hPa = 10.^ln_ps; % Saturation pressure in hPa
%ps_Pa = ps_hPa * 100; % Convert to Pa
%ps_kPa= ps_Pa/1000;
saturated_vapor_pressure=ps_hPa;
% Display results
%fprintf('Saturation Vapor Pressure at %.2f K is %.2f Pa (%.3f kPa)\n', T, ps_Pa, ps_kPa);




end