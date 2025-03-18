function h=coefficients_for_h_water_vapor(f)
    format long g
    Table=[22.235080 2.6846 2.7649; 
        183.310087 5.8905 4.9219; 
        325.152888 2.9810 3.0748];
    A=5.6585*(10^-5);
    B=1.8348;

    alu=0;
    for i=1:3
        kochu=Table(i,2)/( (f-Table(i,1))^2 +Table(i,3) );
        alu=alu+kochu;
    end
    h= A*f + B + alu;
end