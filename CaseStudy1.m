load COVIDbyCounty.mat;

% Split data into training and test sets
% this randomly select 80% of the rows of CNTY_COVID and CNTY_CENSUS for 
% the training set, and uses the remaining 20% for the test set
numCounties = size(CNTY_COVID,1); % record noumber of counties
numTrain = round(0.8*numCounties); % number of counties for the training group

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


% Cluster test data 
k = 5; % number of clusters
[idx, C] = kmeans(testData,k);

% 不确定
figure;
hold on;
for i = 1:k
    cluster_points = testData(idx == i, :);
    scatter(dates(idx == i), cluster_points, 'filled', 'DisplayName', ['Cluster ' num2str(i)]);
end

% Plot centroids
scatter(dates(1), C(:, 1), 100, 'k', 'filled', 'DisplayName', 'Centroid 1');
scatter(dates(1), C(:, 2), 100, 'k', 'filled', 'DisplayName', 'Centroid 2');
hold off;