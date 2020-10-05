load('iris.mat')
k=[3 5 7 9]
g=[0 0 0 0];
n_mean=1000.0
for q=1:1:n_mean
for c=1:1:4
shuffled=randperm(150);
e=[data,labels];

%devide datas to 6 parts
test(1,1:25,:)=e(shuffled(1:25),:);
test(2,1:25,:)=e(shuffled(26:50),:);
test(3,1:25,:)=e(shuffled(51:75),:);
test(4,1:25,:)=e(shuffled(76:100),:);
test(5,1:25,:)=e(shuffled(101:125),:);
test(6,1:25,:)=e(shuffled(126:150),:);
train(1,1:125,:)=e(shuffled(26:150),:);
train(2,1:125,:)=e([shuffled(1:25),shuffled(51:150)],:);
train(3,1:125,:)=e([shuffled(1:50),shuffled(76:150)],:);
train(4,1:125,:)=e([shuffled(1:75),shuffled(101:150)],:);
train(5,1:125,:)=e([shuffled(1:100),shuffled(126:150)],:);
train(6,1:125,:)=e(shuffled(1:125),:);

%test for 6 parts
for test_number=1:1:6
    class1=zeros(1,25);
    class2=zeros(1,25);
    class3=zeros(1,25);
    
    %find the distances of each test data from train datas
    for i=1:1:25
        d=zeros(1,125);
        for j=1:1:125
            for index=1:1:4
                d(j)=((test(test_number,i,index)-train(test_number,j,index))).^2+d(j);
            end
            d(j)=d(j)^.5;
        end
        
        %find k neerest data
        u=1:1:125;
        r=[d',u'];
        sorted_distance=sortrows(r,1);
        k_nearest(1:k(c),:)=sorted_distance(1:k(c),:);
        for t=1:1:k(c)
            if(train(test_number,k_nearest(t,2),5)==1)
                class1(i)=class1(i)+1;
            end
            if(train(test_number,k_nearest(t,2),5)==2)
                class2(i)=class2(i)+1;
            end
            if(train(test_number,k_nearest(t,2),5)==3)
                class3(i)=class3(i)+1;
            end
        end
        
        %choose the class of test data 
        if(class1(i)>=class2(i) & class1(i)>=class3(i))
            choosed_class(i+25*(test_number-1))=1;
        end
        if(class2(i)>=class1(i) & class2(i)>=class3(i))
            choosed_class(i+25*(test_number-1))=2;
        end
        if(class3(i)>=class2(i) & class3(i)>=class1(i))
            choosed_class(i+25*(test_number-1))=3;
        end
    end
        
end

for i=1:1:150
    if(choosed_class(i)==e(shuffled(i),5))
        g(c)=g(c)+1;
    end
end

end


end
for c=1:1:4
    truth(c)=g(c)/n_mean
end
