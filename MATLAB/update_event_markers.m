function [event_markers] = update_event_markers(df_event_markers)

    % Marker for Index, Time and Labels
    event_markers = cell (1,3);


    for n_row = 1:size (df_event_markers,1)

    % Empty row for cells to be stored
    row_cells = table2cell (df_event_markers (n_row,:));

    % Save index, time and label
    event_markers(n_row,1) =  (row_cells (1)); % Index
    hold1 = strsplit (cell2mat (row_cells (2)),' ');
    hold2 = (hold1 (1));
    event_markers(n_row,2) = (hold2); % Time
    event_markers(n_row,3) = row_cells (5); % Label


    end


end

