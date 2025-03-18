function attenuation=Rain_Attenuation(rain_rate,frequency,polarization,theta,L)
    format long g
    polarization = lower(strtrim(polarization));

    if strcmp(polarization, 'horizontal')
        %disp('The frequency is transmitted in vertical polarization.');
        a=zeros(1,4);A=zeros(1,4);
        b=zeros(1,4);B=zeros(1,4);
        c=zeros(1,4);C=zeros(1,4);
        mk=-0.18961;ma=0.67849;
        ck=0.71147;ca=-1.95537;
        k_log=mk*log10(frequency)+ck;
        alpha=ma*log10(frequency)+ca;
        %calculate kH
        for i=1:4
            if i==1
                a(i)=-5.33980;b(i)=-0.10008;c(i)=1.13098;
            elseif i==2
                a(i)=-0.35361;b(i)=1.26970;c(i)=0.45400;
            elseif i==3
                a(i)=-0.23789;b(i)=0.86036;c(i)=0.15354;
            elseif i==4
                a(i)=-0.94158;b(i)=0.64552;c(i)=0.16817;
            end
            k_log=k_log + a(i)*exp(-((log10(frequency)-b(i))/c(i))^2);
            k=10^k_log;
        end

        for j=1:5
            if j==1
                A(j)=-0.14318;B(j)=1.82442;C(j)=-0.55187;
            elseif j==2
                A(j)=0.29591;B(j)=0.77564;C(j)=0.19822;
            elseif j==3
                A(j)=0.32177;B(j)=0.63773;C(j)=0.13164;
            elseif j==4
                A(j)=-5.37610;B(j)=-0.96230;C(j)=1.47828;
            elseif j==5
                A(j)=16.1721;B(j)=-3.29980;C(j)=3.43990;
            end
            alpha=alpha + A(j)*exp(-((log10(frequency)-B(j))/C(j))^2);   
        end

    elseif strcmp(polarization, 'vertical')
        %disp('The frequency is transmitted in horizontal polarization.');
        a=zeros(1,4);A=zeros(1,4);
        b=zeros(1,4);B=zeros(1,4);
        c=zeros(1,4);C=zeros(1,4);
        mk=-0.16398;ma=-0.053739;
        ck=0.63297;ca=0.83433;
        k_log=mk*log10(frequency)+ck;
        alpha=ma*log10(frequency)+ca;
        %calculate kV
        for i=1:4
            if i==1
                a(i)=-3.80595;b(i)=0.56934;c(i)=0.81061;
            elseif i==2
                a(i)=-3.44965;b(i)=-0.22911;c(i)=0.51059;
            elseif i==3
                a(i)=-0.39902;b(i)=0.73042;c(i)=0.11899;
            elseif i==4
                a(i)=0.50167;b(i)=1.07319;c(i)=0.27195;
            end
            k_log=k_log + a(i)*exp(-((log10(frequency)-b(i))/c(i))^2);
            k=10^k_log;
        end

        for j=1:5
            if j==1
                A(j)=-0.07771;B(j)=2.33840;C(j)=-0.76284;
            elseif j==2
                A(j)=0.56727;B(j)=0.95545;C(j)=0.54039;
            elseif j==3
                A(j)=-0.20238;B(j)=1.14520;C(j)=0.26809;
            elseif j==4
                A(j)=-48.2991;B(j)=0.791669;C(j)=0.116226;
            elseif j==5
                A(j)=48.5833;B(j)=0.791459;C(j)=0.116479;
            end
            alpha=alpha + A(j)*exp(-((log10(frequency)-B(j))/C(j))^2);   
        end
    end

    L_eff= L/(1+ 0.78*(L*frequency/sin(theta))^(0.5) -0.38*(1-exp(-2*L)));

    gamma=k*(rain_rate^alpha);

    attenuation=0.012*gamma*L_eff;
    %disp('hi');disp(k);disp(alpha);disp(gamma);disp(L_eff);

    
end