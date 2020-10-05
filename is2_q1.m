tic
load('letter_recognition.mat')
%initializing variables
%n,m,v,b,s and such variables are not important
%important ones have self-explainatory names 
n_train=16000;
layer2(1:26,1:16)=0
e=[train_data(1:n_train,:),train_labels(1:n_train,:)];
n=0;
m=0;
classes(1:26)=0;
class=1;
max=1;
choosed(1:4000,1:26)=0;
number_choosed(1:4000,1:26)=0;

%we make 26 class and test each data on all of them
for class=1:1:26
    max=1;
    clear dd;
    dd=make_tree([1:16],e,class,1,1);
    v=1;
    b=1;
    for test=1:1:4000
    level=1;
    column=1; 
    flag1=0;
    flag2=0;
    flag3=0;
    for ll=1:4:length(dd)
        if(dd(ll)>max)
            max=dd(ll);
        end
        if(dd(ll)==level & dd(ll+1)==column )
            %noting important is going on in these 3 "if",ignore them
                if(test_labels(test)==class)
                    flag1=1;
                end
                if(dd(ll+2)==-2 & test_labels(test)==class)
                    ff(class,b)=test;
                    b=b+1;
                    m=m+1;
                    flag3=1;
                end 
                if(dd(ll+2)==-2)
                    f(class,v)=test;
                    v=v+1;
                    n=n+1;
                    flag2=1;
                    
                    %save all classes that can be candidated for this data
                    choosed(test,class)=1;
                    number_choosed(test,class)=dd(ll+3);
                    break;
                end 
                if(dd(ll+2)>0)
                    next=test_data(test,dd(ll+2));
                else
                    break;
                end
                
                %find the next node
                level=level+1;
                column=(column-1)*16+next+1;
                dd(ll+2);
        end
    end 
    end
    
    %saveing first and second layer of trees
    jj=1;
    layer1(class)=dd(3)
    for ll=1:4:length(dd)
        if(dd(ll)==2)
            layer2(class,jj)=dd(ll+2);
            jj=jj+1;
        end
    end
end
summ=sum(choosed,2);
s=0;
xx=0;
confusion(1:27,1:26)=0;

%choose best class for each data based on true population
for i=1:1:4000
   % if(summ(i)>1)
        max_index=-1;
        max_true=0;
        for j=1:1:26
            if(number_choosed(i,j)>max_true)
                max_index=j;
                max_true=number_choosed(i,j);
            end
        end
        result(i)=max_index;
        if(summ(i)>0)
            if(test_labels(i)~=max_index)
                n=n-1;
                s=s+1;
            end
        end
        
    %end
        if(result(i)==test_labels(i))
            confusion(result(i),result(i))= confusion(result(i),result(i))+1;
            xx=xx+1;
        else
            if(result(i)>0)
                confusion(result(i),test_labels(i))= confusion(result(i),test_labels(i))+1;
            else
                confusion(27,test_labels(i))= confusion(27,test_labels(i))+1;
            end
        end
    
end

toc