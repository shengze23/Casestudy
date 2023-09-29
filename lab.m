load COVIDbyCounty.mat
[talB,index]=sortrows(CNTY_CENSUS,"POPESTIMATE2021",'descend');
Popestimate=CNTY_CENSUS(:,6);
figure;
for i=1:9
    hold on;
    plot(dates,CNTY_COVID(index(i),:));
end
xlabel("date");
ylabel("cases");
legend("county1", "county2","county3","county4","county5","county6","county7","county8","county9");
hold off;

