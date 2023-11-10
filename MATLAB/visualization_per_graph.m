function output = visualization_per_graph(signal,title_name,t)

figure;
plot (t,signal);
title (title_name);
xlabel ('Time (s)');
ylabel ('Amplitude');
set(gcf,'Position',[100 100 1000 400]);

output = 0;
end

