function [output] = windowing(signal,w)


% Finding the length required for padded zeros
% Window - Remainder
padding_n = w - rem (length (signal), w);
padding = zeros (padding_n,1);

% Signal becomes padded at the end
newsig = [signal;padding];

output = reshape (newsig, w, []);

% Example: Window size = 10000 and the signal is 1600000
% This will create 160 windows each with a window size of 10000
% Where w = 10000samples is t = 2sec

end

