
%% 

testing_labels = zeros(numTest,1);

for i = 1:numTest
    [r,c] = min(norm_table(i,:));
    testing_labels(i,:) = c; 
end

%% 