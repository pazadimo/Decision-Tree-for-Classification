function [outs]=make_tree(attributes,datas,class,level,column)
     number_of_childs(1:length(attributes),1:16)=0;
     t=0;
     f=0;
     trues(1:length(attributes),1:16)=0;
     falses(1:length(attributes),1:16)=0;
     
     %calculating the population of each child in the case of choosing each atribute
     %also calculating the number of input datas with true and false labels in each child
     for atts=1:1:length(attributes)
       for possibles=1:1:16
           for data=1:1:length(datas(:,1))
               if(datas(data,atts)==(possibles-1))
                   number_of_childs(atts, possibles)=number_of_childs(atts, possibles)+1;
                   if(datas(data,17)==class)
                       ff=trues(atts, possibles)+1;
                       trues(atts, possibles)=ff;
                   end
                   if(datas(data,17)~=class)
                       ff=falses(atts, possibles)+1;
                       falses(atts, possibles)=ff;
                   end
               end 
           end
       end
     end
    
    %calculating the number of input datas with true and false labels in this node
    for data=1:1:length(datas(:,1))
        if(datas(data,17)==class)
            t=t+1;
        end
        if(datas(data,17)~=class)
            f=f+1;
        end
    end
    
    % return in the case of reaching leaf 
    if(t==0)
        f=f;
        outs=[level,column,-1,f];
        return
    end
    if(f==0)
        t=t;
        outs=[level,column,-2,t];
        return
    end
    if(length(attributes)==1)
        if(t>=0.6*f)
            outs=[level,column,-2,t+f];
        else
        outs=[level,column,-1,t+f];
        end
        return
    end
    
    %estimating the node entropy
    Et=(-t)/(t+f)*log2(t/(t+f))-f/(t+f)*log2(f/(t+f));
    
    %calculating information gain for each attribute
    gain(1)=1;
    for atts=1:1:length(attributes)
        c=0.0;
       for possibles=1:1:16
           if((trues(atts,possibles)+falses(atts,possibles)) ~= 0)
               i1=number_of_childs(atts, possibles)/(t+f);
               i2=(trues(atts,possibles))/(trues(atts,possibles)+falses(atts,possibles));
               i3=(falses(atts,possibles))/(trues(atts,possibles)+falses(atts,possibles));
               if(i2==0 || i3==0 )
                   c=c;
               else
                c=c+i1*(-1*i2*(log2(i2))+(-1*i3)*log2(i3));
               end
           end
       end
       gain(atts)=Et-c;
    end
    
    %choose the attribute with biggest IG
    [~,max_index]=max(gain);
    
    %update attributes to pass children
    if(max_index==1)
        new_attributes=attributes(2:(length(attributes)));
    elseif(max_index==length(attributes))
        new_attributes=attributes(1:(length(attributes)-1));
    else
        new_attributes=attributes([1:(max_index-1),(max_index+1):(length(attributes))]);
    end
    
    
    %now we call function for each child
    next=[];
    for possibles=1:1:16
        c=1;
        clear childs_data;
        for data=1:1:length(datas(:,1))
            if(datas(data,attributes(max_index))==possibles-1)
                   childs_data(c,:)=datas(data,:);
                   c=c+1;
            end
        end
        
        %in this part we paste outs of each child to each other
        if(c~=1)
            a=next;
            next=[a,make_tree(new_attributes,childs_data,class,level+1,16*(column-1)+possibles)];
        end
    end
    o=[level,column,attributes(max_index),-10];
    outs=[o,next];
    return
end