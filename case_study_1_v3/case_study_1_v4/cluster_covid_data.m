close all;
load COVIDbyCounty.mat;
rng default;
%% 
% Split data into training and test sets
% this randomly select 80% of the rows of CNTY_COVID and CNTY_CENSUS for 
% the training set, and uses the remaining 20% for the test set
numCounties = size(CNTY_COVID,1); % record noumber of counties
numTrain = round(0.8*numCounties); % number of counties for the training group

numTest = size(CNTY_COVID,1) - numTrain;

%choose numTrain number of counties in numCounties to be trainIndex
trainIdx = randperm(numCounties,numTrain);  
% 在numCounties中随机选择numTrain 个，成为trainIdx

%The counties that did not appear in trainIdx will be stored in testIdx
testIdx = setdiff(1:numCounties,trainIdx);
% 1-255个countie中其中没有在 trainIdx中出现过的将会被存储在testIdx中


trainData = CNTY_COVID(trainIdx,:);
testData = CNTY_COVID(testIdx,:);

trainCensus = CNTY_CENSUS(trainIdx,:); 
testCensus = CNTY_CENSUS(testIdx,:);


% Plot test data points  
figure;
plot(dates,testData);

% Add labels
xlabel('Date'); 
ylabel('COVID Cases');
title('Test data points before clustering') 

%% 
%TRAINING DATA CLUSTERING
% Cluster test data 
k = 18; % number of clusters
[idx, C] = kmeans(trainData,k,'Replicates',200);
%kmeans based on angles
[idx_angle,C_angle] = kmeans(trainData,k,'Distance','cosine','Replicates',200);
%% 


%getting the accuracy of the k number we use

%creating an array to store which cluster refer to each division 
cluster_labels  = zeros(k,2);

cluster_labels_angle = zeros(k,2);

%find the most common division in a cluster first, then find the number of
%this division in this cluster to calculate the percentage of this
%division.
for i = 1:k
    most_common_divnum_i = mode(trainCensus.DIVISION(idx==i));
    count_mostdivnum_i = sum(trainCensus.DIVISION(idx==i) == most_common_divnum_i);
    percentage_most_i = (count_mostdivnum_i/numel(trainCensus.DIVISION(idx==i)))*100;
    fprintf('accuracy is %d.\n',percentage_most_i);
    %finding what division each cluster represent
    disp(trainCensus.DIVNAME(most_common_divnum_i,:));
    disp(trainCensus.DIVISION(most_common_divnum_i,:));
    fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
    %assigning labels to training_labels
    cluster_labels(i,1) = i;
    cluster_labels(i,2) = most_common_divnum_i;
end


%% 
%angle
for i = 1:k
    most_common_divnum_i_angle = mode(trainCensus.DIVISION(idx_angle==i));
    count_mostdivnum_i_angle = sum(trainCensus.DIVISION(idx_angle==i) == most_common_divnum_i);
    percentage_most_i_angle = (count_mostdivnum_i/numel(trainCensus.DIVISION(idx_angle==i)))*100;
    fprintf('accuracy is %d.\n',percentage_most_i);
    %finding what division each cluster represent
    disp(trainCensus.DIVNAME(most_common_divnum_i_angle,:));
    disp(trainCensus.DIVISION(most_common_divnum_i_angle,:));
    fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
    %assigning labels to training_labels
    cluster_labels_angle(i,1) = i;
    cluster_labels_angle(i,2) = most_common_divnum_i_angle;
end







%TESTING DATA VALIDATION

norm_table = [];
norm_table_row = [];

for i = 1:numTest
    for j = 1:k
        norm_j = norm(testData(i,:)-C(j,:));
        norm_table_row = [norm_table_row, norm_j];
    end
    norm_table = [norm_table; norm_table_row];
    norm_table_row = [];
end

%Testing Data Validation based on angles

angle_table = [];
angle_table_row = [];

for i = 1:numTest
    for j = 1:k
        angle_j = acos(dot(testData(i,:),C_angle(j,:))/(norm(testData(i,:))*norm(C_angle(j,:))));
        angle_table_row = [angle_table_row, angle_j];
    end
    angle_table = [angle_table; angle_table_row];
    angle_table_row = [];
end

