function [output] = windowing_per_sig(vr1,w)


    % PPG
    PPG_VR1_windowed = windowing (vr1.CH2, w);

    % GSR
    GSR_VR1_windowed = windowing (vr1.CH14, w);

    % RI
    RI_VR1_windowed = windowing (vr1.CH1, w);
    RI_RR_elevated_VR1_windowed = windowing (vr1.CH43, w);
    RI_RR_VR1_windowed = windowing (vr1.CH42, w);
    
    % ECG
    ECGPR_VR1_windowed = windowing (vr1.CH40, w);
    ECGRR_VR1_windowed = windowing (vr1.CH41, w);
    ECG_VR1_windowed = windowing (vr1.CH13, w);
    
    output = {
    RI_VR1_windowed,... % RI
    PPG_VR1_windowed,... %PPG
    ECG_VR1_windowed,... % ECG
    GSR_VR1_windowed,... %GSR
    ECGPR_VR1_windowed,... 
    ECGRR_VR1_windowed,...
    RI_RR_VR1_windowed,...
    RI_RR_elevated_VR1_windowed,...
    };
    
    


end

