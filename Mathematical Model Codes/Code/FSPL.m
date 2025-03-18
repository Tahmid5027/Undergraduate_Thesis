function loss=FSPL(f,d)
    loss=20*log10(4*pi.*(f.*1e9)*(d*1e3)/(3e8));
end