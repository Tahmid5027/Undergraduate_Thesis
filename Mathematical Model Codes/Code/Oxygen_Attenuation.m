function Attenuation=Oxygen_Attenuation(frequency,Ts,Ps,row_ws,p,e,theta)
    %parameters
    % frequency== transmitted frequency
    % Ts== instantaneous surface pressure
    % Ps== instantaneous total (baromatrc) pressure
    % row_ws==instantaneous surface water vapor density
    % p==dry air pressure
    % e==water vapor partial pressure
    % theta==elevation angle
    %theta=theta*pi/180;
    format long g
    gamma=0.1820*0.011*frequency*N_DoublePrime_oxygen_Calculation(frequency,p,e,theta);
    Attenuation=gamma*cofficients_for_h_oxygen(frequency,Ts,Ps,row_ws)/sin(theta*pi/180);
end