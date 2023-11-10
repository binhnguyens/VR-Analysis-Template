function time = s2t(sig)

% Sample to Time

fs = 2000; % Sampled at 0.5 ms/sample
samples = 1:length (sig);    
time = samples / fs;



end

