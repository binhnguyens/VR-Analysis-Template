function [output] = hrv_features_time (RR)

%% Pre Processing

% % Removing 0 values for RR 
% in = find(RR>0,1);
% RR (1: in) = [];

%% HRV time features

% RMSSD
% (RR interval n - RR interval n+1) ^2 
hold1 = diff (RR).^2;
RMSSD = sqrt (mean (hold1));

output = [RMSSD].';

end

