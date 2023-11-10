function [output] = normalization(signal)

maximus = max (signal);
minimus = min (signal);

output = (signal - minimus) / (maximus - minimus);


end

