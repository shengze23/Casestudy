load COVIDbyCounty.mat;
%% 

% Split data into training and test sets
% this randomly select 80% of the rows of CNTY_COVID and CNTY_CENSUS for 
% the training set, and uses the remaining 20% for the test set
numCounties = size(CNTY_COVID,1); % record noumber of counties
numTrain = round(0.8*numCounties); % number of counties for the training group

numTest = size(CNTY_COVID,1) - numTrain;


trainIdx = randperm(numCounties,numTrain); % 在numCounties中随机选择numTrain
% 个，成为trainIndex
testIdx = setdiff(1:numCounties,trainIdx); % 1-255个countie中其中没有在
% trainIdx中出现过的将会被存储在testIdx中

trainData = CNTY_COVID(trainIdx,:);
testData = CNTY_COVID(testIdx,:);

trainCensus = CNTY_CENSUS(trainIdx,:); 
testCensus = CNTY_CENSUS(testIdx,:);

test_Data_Census=[testCensus, table(testData)];
train_Data_Census=[trainCensus,table(trainData)];


% Plot test data points  
figure;
plot(dates,testData,'LineWidth', 1.5);

% Add labels
xlabel('Date'); 
ylabel('COVID Cases');
title('Test data points before clustering') 

%% 
%TRAINING DATA CLUSTERING
% Cluster test data 
k = 18; % number of clusters
[idx, C] = kmeans(trainData,k,'Replicates',200);



%getting the accuracy of the k number we use


%
cluster_labels  = zeros(k,2);



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

%% 

testing_labels = zeros(numTest,1);

for i = 1:numTest
    [r,c] = min(norm_table(i,:));
    testing_labels(i,:) = c; 
end

%% 
%testing accuracy

score = 0;

testing_labels_withDivnum = [testing_labels,testCensus.DIVISION];

for i = 1:numTest
    if testing_labels_withDivnum(i,2) == cluster_labels(testing_labels_withDivnum(i,1),2)
        score = score + 1;
    end
end

accuracy = (score/length(testData(:,1)))*100;

disp(accuracy);

%% 

