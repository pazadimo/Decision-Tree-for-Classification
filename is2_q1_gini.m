load('letter_recognition.mat')
n_train=16000;
e=[train_data(1:n_train,:),train_labels(1:n_train,:)];
n=0;
m=0;
classes(1:26)=0;
for train=1:1:4000
    classes(train_labels(train))=classes(train_labels(train))+1;
end
class=1
max=1
confusion(1:26,1:2,1:2)=0;
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
%             if(dd(ll+2)==-2)
%                 b=b+1
%             end
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
        if(flag1==1 & flag2==1)
            confusion(class,1,1)=confusion(class,1,1)+1;
        elseif(flag1==0 & flag2==1)
            confusion(class,1,2)=confusion(class,1,2)+1;
        elseif(flag1==1 & flag2==0)
            confusion(class,2,1)=confusion(class,2,1)+1;
        elseif(flag1==0 & flag2==0)
            confusion(class,2,2)=confusion(class,2,2)+1;
        end
  end
end