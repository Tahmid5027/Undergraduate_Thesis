function Attenuation=WaterVapor_Attenuation(f,p,e,theta)
    format long g
    gamma=0.1820*f*N_DoublePrime_WaterVapour_Calculation(f,p,e,theta);
    Attenuation=gamma*coefficients_for_h_water_vapor(f)/sin(theta*pi/180);
end