function N_doublePrime_D_oxygen=N_DoublePrime_D_oxygen_Calculation(f,p,e,theta)
    format long g
    theta=theta*pi/180;
    d=5.6*(10^-4)*(p+e)*(theta^0.8);
    alu=(6.14*(10^-5))/(d*(1+ ((f/d)^2)  ));
    kochu=(1.4*(10^-12)*p*(theta^1.5))/(1+ 1.9*(f^1.5)*(10^-5));
    N_doublePrime_D_oxygen=f*p*(theta^2)&(alu+kochu);
end