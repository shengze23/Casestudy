%plotting

smoothed_testData = movmean(testData, 25);

smoothed_centroids = movmean(centroids,25);

%% 

for i = 1:9

    titleString = sprintf('Division: %d', i);

    plot_testing_idx_i = testCensus.DIVISION == i;
    plot_testing_cnty_i = smoothed_testData(plot_testing_idx_i,:);
    subplot(3,3,i);

    hold on;
    plot(dates,smoothed_centroids(centroid_labels==i,:),'LineWidth',1.5);
    plot(dates,plot_testing_cnty_i);
    title(titleString);
    hold off;
end

%% 


