load COVIDbyCounty.mat;

% Split data into training and test sets
% this randomly select 80% of the rows of CNTY_COVID and CNTY_CENSUS for 
% the training set, and uses the remaining 20% for the test set
numCounties = size(CNTY_COVID,1); % record noumber of counties
numTrain = round(0.8*numCounties); % number of counties for the training group

trainIdx = randperm(numCounties,numTrain); % 在numCounties中随机选择numTrain个，成为trainIndex
testIdx = setdiff(1:numCounties,trainIdx); % 1-255个countie中其中没有在trainIdx中出现过的将会被存储在testIdx中

trainData = CNTY_COVID(trainIdx,:);
testData = CNTY_COVID(testIdx,:);

trainCensus = CNTY_CENSUS(trainIdx,:); 
testCensus = CNTY_CENSUS(testIdx,:);

% Cluster training data 
k = 9; % number of clusters
[centroids, idx] = kmeans(testData,k);


