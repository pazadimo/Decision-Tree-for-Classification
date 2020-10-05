load('iris.mat')
k=[3 5 7 9]
g=[0 0 0 0];



e=[data,labels];

for round=1:1:5
%do this lgorithm for all k: 3 5 7 9
for c=1:1:4
    
    %makeing a vector for choosing 150 data randomly
    shuffled=randperm(150);
    train(1:150,:)=e(shuffled(1:150),:);
    
    %initializing the branches and centers
    branch(1:k(c),1,1:5)=-1;
    center(1:k(c),:)=e(shuffled(1:k(c)),:);
    branch(1:k(c),1,1:5)=center(1:k(c),:);
    b_length(1:k(c))=1;
    
    %choose each data one by one randomly and put it in best branch based
    %on distances from each center
    for i=k(c)+1:1:150
        d=zeros(1,k(c));
        for j=1:1:k(c)
            for index=1:1:4
                d(j)=(e(shuffled(i),index)-center(j,index))^2+d(j);
            end
            d(j)=sqrt(d(j));
        end
        
        %choose the nearest center to data
        u=1:1:k(c);
        r=[d',u'];
        sorted_distance=sortrows(r,1);
        choosed=sorted_distance(1,2);
        
        %updating centers and datas
        center(choosed,:)=(center(choosed,:)*b_length(choosed)+e(shuffled(i),:))/(b_length(choosed)+1);
        b_length(choosed)=b_length(choosed)+1;
        branch(choosed,b_length(choosed),:)=e(shuffled(i),:);
    end
    
    %in this part we find inner distances of branches.
    for i=1:1:k(c)
        in_distance(c,i)=0;
        for j=1:1:b_length(i)
            
            for index=1:1:4
                in_distance(c,i)=(branch(i,j,index)-center(i,index))^2+in_distance(c,i);
            end 
        end
        in_distance(c,i)=in_distance(c,i)^.5;
        in_distance(c,i)=in_distance(c,i)*b_length(i);
    end
    
    %in this part we find out distances of branches.
    for i=1:1:k(c)
        out_distance(c,i)=0;
        for j=1:1:k(c)
            for index=1:1:4
                out_distance(c,i)=(center(i,index)-center(j,index))^2+out_distance(c,i);
            end
        end
        out_distance(c,i)=out_distance(c,i)^.5;
        %decision_distance(c,i)=out_distance(c,i)/in_distance(c,i)
    end
end
res(round,:)=sum(out_distance,2)./sum(in_distance,2)
end
