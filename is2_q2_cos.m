load('iris.mat')

k=[9]
g=[0 0 0 0];
n_mean=100.0
for q=1:1:n_mean
for c=1:1:1
shuffled=randperm(150);
e=[data,labels];

%devide datas to 3 parts
test(1,1:50,:)=e(shuffled(1:50),:);
test(2,1:50,:)=e(shuffled(51:100),:);
test(3,1:50,:)=e(shuffled(101:150),:);
train(1,1:100,:)=e(shuffled(51:150),:);
train(2,1:100,:)=e([shuffled(1:50),shuffled(101:150)],:);
train(3,1:100,:)=e(shuffled(1:100),:);

%test for 3 parts
for test_number=1:1:3
    class1=zeros(1,50);
    class2=zeros(1,50);
    class3=zeros(1,50);
    
    %find the distances of each test data from train datas
    for i=1:1:50
        d=zeros(1,100);
        first(i,:)=test(test_number,i,1:4);
        for j=1:1:100
            for index=1:1:4
                d(j)=((test(test_number,i,index)*train(test_number,j,index)))+d(j);
            end
            
            second(j,:)=train(test_number,j,1:4);
            d(j)=1-d(j)/(norm(first(i,:))*norm(second(j,:)));
        end
        
        %find k neerest data
        u=1:1:100;
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
            choosed_class(i+50*(test_number-1))=1;
        end
        if(class2(i)>=class1(i) & class2(i)>=class3(i))
            choosed_class(i+50*(test_number-1))=2;
        end
        if(class3(i)>=class2(i) & class3(i)>=class1(i))
            choosed_class(i+50*(test_number-1))=3;
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
