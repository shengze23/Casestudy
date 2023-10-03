centroids = C;

centroid_labels = cluster_labels(:,2);

%% 
%testing accuracy

score = 0;

score_angle = 0;


testing_labels_withDivnum = [testing_labels,testCensus.DIVISION];

testing_labels_angle_withDivnum = [testing_labels_angle,testCensus.DIVISION];

for i = 1:numTest
    if testing_labels_withDivnum(i,2) == cluster_labels(testing_labels_withDivnum(i,1),2)
        score = score + 1;
    end
    if testing_labels_angle_withDivnum(i,2) == cluster_labels_angle(testing_labels_angle_withDivnum(i,1),2)
        score_angle = score_angle +1 ;
    end
end

accuracy = (score/length(testData(:,1)))*100;

accuracy_angle = (score_angle/length(testData(:,1)))*100;
disp(accuracy);
disp('~~~~~');
disp(score_angle);

%%