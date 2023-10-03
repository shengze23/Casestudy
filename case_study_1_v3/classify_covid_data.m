
%% 

testing_labels = zeros(numTest,1);

for i = 1:numTest
    [r,c] = min(norm_table(i,:));
    testing_labels(i,:) = c; 
end

%% 
%angle

testing_labels_angle = zeros(numTest,1);

for i  = 1:numTest
    [r_angle,c_angle] = min(angle_table(i,:));
    testing_labels_angle(i,:) = c_angle;
end
%% 
