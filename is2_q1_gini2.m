load('letter_recognition.mat')
n_train=16000;
e=[train_data(1:n_train,:),train_labels(1:n_train,:)];
n=0;
m=0;
classes(1:26)=0;
% for train=1:1:4000
%     classes(train_labels(train))=classes(train_labels(train))+1;
% end
class=1;
max=1;
% confusion(1:26,1:2,1:2)=0;
choosed(1:4000,1:26)=0;
number_choosed(1:4000,1:26)=0;
for class=1:1:26
    max=1;
    class
    clear dd;
    dd=make_gini([1:16],e,class,1,1);
 %   t(i)=length(dd);
    v=1;
    b=1;
    for test=1:1:4000
    % test=20;
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
                    choosed(test,class)=1;
                    number_choosed(test,class)=dd(ll+3);
                    break;
                end 
                if(dd(ll+2)>0)
                    next=test_data(test,dd(ll+2));
                else
                    break;
                end
                level=level+1;
                column=(column-1)*16+next+1;
                dd(ll+2);
        end
    end 
%         if(flag1==1 & flag2==1)
%             confusion(class,1,1)=confusion(class,1,1)+1;
%         elseif(flag1==0 & flag2==1)
%             confusion(class,1,2)=confusion(class,1,2)+1;
%         elseif(flag1==1 & flag2==0)
%             confusion(class,2,1)=confusion(class,2,1)+1;
%         elseif(flag1==0 & flag2==0)
%             confusion(class,2,2)=confusion(class,2,2)+1;
%         end
    
    end
end
summ=sum(choosed,2);
s=0;
xx=0;
confusion(1:27,1:26)=0;
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
%  total_confusion(1,1)=n;
%  total_confusion(2,2)=sum(confusion(1:26,2,2));
%  total_confusion(1,2)=sum(confusion(1:26,1,2));
%  total_confusion(2,1)=sum(confusion(1:26,2,1));