function [output] = feature_set_loop(matrix)

    n = length (matrix);
   

    %% Local Features
    % Features: Columns = number of windows of entire signal // Rows = Window sample
    % Mean and Variance of the Variance of the windows
    
    % Empty matrix with Number of windows x Number of Signals
    output1 = zeros (size(matrix{1},2),size(matrix,2));
    output2 = zeros (size(matrix{1},2),size(matrix,2));

    for i = 1:n
        signal = matrix{i};
        output1 (:,i) = mean (signal,1);
        output2 (:,i) = var (signal,1);
    end
    
    output = [output1,output2];

end

