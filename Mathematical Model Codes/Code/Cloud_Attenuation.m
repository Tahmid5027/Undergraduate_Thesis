function attenuation=Cloud_Attenuation(f,T,row,H,theta)
    % row = liquid water density in the cloud or fog (g/m3)

    epsilon_not=77.66 + 103.3*((300/T)-1);
    epsilon_1=0.0671*epsilon_not;
    epsilon_2=3.52;
    fp=20.20- 146*((300/T)-1) +316*((300/T)-1)^2;
    fs=39.8*fp;

    alu1=f*(epsilon_not-epsilon_1)/(fp * (1+ (f/fp)^2   )    );
    kochu1=f*(epsilon_1-epsilon_2)/(fs * (1+ (f/fs)^2   )    );
    epsilon_double_prime= alu1+kochu1;

    alu2=(epsilon_not-epsilon_1)/(1+ (f/fp)^2  );
    kochu2=(epsilon_1-epsilon_2)/(1+ (f/fs)^2  );
    epsilon_prime=alu2+kochu2+epsilon_2;

    eta=(2+epsilon_prime)/epsilon_double_prime;

    Kl=0.819*f/( epsilon_double_prime * (1+ eta^2) );

    gamma=Kl*row;
    L= H/sin(theta*pi/180);

    attenuation=gamma*L;

end