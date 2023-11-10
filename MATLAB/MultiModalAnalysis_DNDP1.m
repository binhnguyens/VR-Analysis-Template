% Date: Sept 26, 2023
% File to analyze VR Study

clc;clear;
par_num = 1;

%% Add path file to CSV or TXT files
% Main file
path = ('/Users/binhnguyen/Desktop/Desktop/Digital Mental Health/2. Data and Analysis/Biopac Data/');

% Participant files and Event markers
switch par_num
    case 1
        filename1 = ('Session 1 - May 31/2021-05-31 Participant 1.csv');
        filename2 = ('Session 1 - May 31/event markers p1.csv');
        
    case 2
        filename1 = ('Session 1 - May 31/2021-05-31 Participant 2.csv');
        filename2 = ('Session 1 - May 31/event markers p2.csv');
        
    case 3
        filename1 = ('Session 1 - May 31/2021-05-31 Participant 3.csv');
        filename2 = ('Session 1 - May 31/event markers p3.csv');
    
    otherwise
        fprintf ("False response");
        
end

file = strcat ( path , filename1 );

event_marker_file = strcat ( path , filename2 );


%% Open files - Raw Signals and Event Markers
df = readtable (file);

% Retrieve the event markers
df_event_markers = readtable (event_marker_file);
df_EM = update_event_markers (df_event_markers);

% Remove first row
df(1,:) = [];

%% Assign value
% NOTE: Normalization might cause data leakage, should be done within the analysis

% Commenting out the other since they're not needed
ECG = normalization (df.CH13);
% RI = normalization (df.CH1);
% PPG = normalization (df.CH2);
% GSR = normalization (df.CH14);
% ECG_PR =  (df.CH40);
% ECG_RR =  (df.CH41);
% Respiration_Rate =  (df.CH42);
% Respiration_Rate_elevated =  (df.CH43);

t = s2t(ECG);

% Sampling frequency
fs = 2000;

%% Visualize

choice = 2;

if choice == 0

    visualization_per_graph(RI,'RI',t);
    visualization_per_graph(ECG,'ECG',t);
    visualization_per_graph(PPG,'PPG',t);
    visualization_per_graph(GSR,'GSR',t);
    
elseif choice == 1
 
    visualization_subplots (RI,PPG,ECG,GSR,t);
    
else
    
    % Skip
    
end

%% Important segments 1

% Find segments of start and end of each experiment
vr1_start = df_EM (4,2);
vr1_end = df_EM(24,2);

vr2_start = df_EM (26,2);
vr2_end = df_EM (46,2);

% Segment signals into vr1 and vr2
vr1 = df (t2s (str2double (vr1_start)):t2s (str2double (vr1_end)), :);
vr2 = df (t2s (str2double (vr2_start)):t2s (str2double (vr2_end)), :);

fprintf ('\nLength of VR1 is %f seconds\n',(size (vr1,1))/fs)
fprintf ('\nLength of VR2 is %f seconds\n',(size (vr2,1))/fs)

%% Important segments 2

% Find segments of prebrief start and end
pre_start = df_EM(1,2);
pre_end = df_EM (4,2);

% Find segments of debrief start and end
post_start = df_EM (46,2);
post_end = length (ECG)/fs; 

% Segment signals into vr1 and vr2
pre = df (t2s (str2double (pre_start))+1:t2s (str2double (pre_end)), :);
post = df (t2s (str2double (post_start)):t2s (post_end), :);

fprintf ('\nLength of Pre is %f seconds\n',(size (pre,1))/fs)
fprintf ('\nLength of Post is %f seconds\n',(size (post,1))/fs)

%% Windowing data and creating Feature set

w= t2s (5); % 5 seconds 

%%%%% VR 1 
window_matrix_VR1 = windowing_per_sig (vr1,w);

%%%%% VR 2
window_matrix_VR2 = windowing_per_sig (vr2,w);

%%%%% Pre
window_matrix_pre = windowing_per_sig (pre,w);

%%%%% Post
window_matrix_post = windowing_per_sig (post,w);

% Each column represent a window s/t window size x number of windows


%% Feature extract
% Global: Mean 
% Local: Variance 
% One set of mean values (Entire signal)
% Two sets of variance values (Variance and mean of the windows)

[local_set_pre] = feature_set_loop (window_matrix_pre);
[local_set_VR1] = feature_set_loop (window_matrix_VR1);
[local_set_VR2] = feature_set_loop (window_matrix_VR2);
[local_set_post] = feature_set_loop (window_matrix_post);


%% HRV features 
% Channel 41 is the RR Interval

HRV_pre_time = hrv_features_time (window_matrix_pre{6});
HRV_VR1_time = hrv_features_time (window_matrix_VR1{6});
HRV_VR2_time = hrv_features_time (window_matrix_VR2{6});
HRV_post_time = hrv_features_time (window_matrix_post{6});

HRV_pre_frequency = hrv_features_frequency (window_matrix_pre{6},fs,1);
HRV_VR1_frequency = hrv_features_frequency (window_matrix_VR1{6},fs,1);
HRV_VR2_frequency = hrv_features_frequency (window_matrix_VR2{6},fs,1);
HRV_post_frequency = hrv_features_frequency (window_matrix_post{6},fs,1);

HRV_pre = [HRV_pre_time, HRV_pre_frequency];
HRV_VR1 = [HRV_VR1_time, HRV_VR1_frequency];
HRV_VR2 = [HRV_VR2_time, HRV_VR2_frequency];
HRV_post = [HRV_post_time, HRV_post_frequency];

%% Feature matrices
feature_set_VR1 = [local_set_VR1,HRV_VR1];
feature_set_VR2 = [local_set_VR2,HRV_VR2];
feature_set_pre = [local_set_pre,HRV_pre];
feature_set_post =[local_set_post,HRV_post];

%% MAT file conversion 
% 
% % Python_FS is organized for 1. VR1 2. VR2 3. Pre and 4. Post
% 
% n = size(feature_set_VR1,2);
% python_FS = zeros (4, n);
% 
% python_FS (1,:) =  (feature_set_VR1);
% python_FS (2,:) =  (feature_set_VR2);
% python_FS (3,:) =  (feature_set_pre);
% python_FS (4,:) =  (feature_set_post);
% 
% % % Normalization 
% % python_FS_1 = zeros (4, n);
% % for i = 1:n
% %     python_FS_1 (:,i) = normalization (python_FS (:,i))
% % end
% % 
% % python_FS = python_FS_1; 
% 
% par = int2str(par_num);
% 
% save(['python_FS_P', par,'.mat'],'python_FS');