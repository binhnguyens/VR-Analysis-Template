function [output] = hrv_features_frequency(RR,fs,choice)

%% Periodogram
if (choice == 1)
    [ps_peri,fs_peri] = periodogram(RR,rectwin(length(RR)),length(RR),fs);;
    ps = ps_peri;
    f = fs_peri;

elseif (choice == 2)
    [ps_welch,fs_welch] = pwelch (RR);
    ps = ps_welch;
    f = fs_welch;
    
else
    fprint ("Incorrect input");

end

%% Power band
% Low frequency
lf = bandpower(ps,f,[0.04 0.15],'psd'); 
% Very low frequency
vlf = bandpower(ps,f,[0 0.04],'psd');
% High frequency
hf = bandpower(ps,f,[0.15 0.4],'psd');
% HF/LF
hflf = hf./lf;

output = [lf; hf; vlf; hflf].';

end

