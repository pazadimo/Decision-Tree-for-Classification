function [outs]=make_gini(attributes,datas,class,level,column)
     number_of_childs(1:length(attributes),1:16)=0;
     t=0;
     f=0;
     trues(1:length(attributes),1:16)=0;
     falses(1:length(attributes),1:16)=0;
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
    for data=1:1:length(datas(:,1))
        if(datas(data,17)==class)
            t=t+1;
        end
        if(datas(data,17)~=class)
            f=f+1;
        end
    end
    if(t==0)
        f=f;
        outs=[level,column,-1,f];
        return
      %  disp('ggg')
    end
    if(f==0)
        t=t;
        outs=[level,column,-2,t];
       % disp('fff');
        return
       % disp('ggg')
    end
%     if(t>=1.5*f)
%             outs=[level,column,-2,t+f];
%             return
%     end
    if(length(attributes)==1)
        if(t>=f)
            outs=[level,column,-2,t+f];
        elseif(f>100*t)
            outs=[level,column,-1,t+f];
        else
        outs=[level,column,-2,t+f];
        end
       % disp('fff');
        return
       % disp('ggg')
    end
    Et=(-t)/(t+f)*log2(t/(t+f))-f/(t+f)*log2(f/(t+f));
    gain(1)=1;
    for atts=1:1:length(attributes)
        c=0.0;
       for possibles=1:1:16
           if((trues(atts,possibles)+falses(atts,possibles)) ~= 0 )
               i1=number_of_childs(atts, possibles)/(t+f);
               i2=(trues(atts,possibles))/(trues(atts,possibles)+falses(atts,possibles));
               i3=(falses(atts,possibles))/(trues(atts,possibles)+falses(atts,possibles));
                c=c+i1*(1-i2^2-i3^2);
               
           end
       end
       gain(atts)=c;
    end
    [~,max_index]=max(gain);
    if(max_index==1) 
        new_attributes=attributes(2:(length(attributes)));
    elseif(max_index==length(attributes))
        new_attributes=attributes(1:(length(attributes)-1));
    else
        new_attributes=attributes([1:(max_index-1),(max_index+1):(length(attributes))]);
    end
    new_attributes;
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
        if(c~=1)
            a=next;
         %   if(level < 3)
                next=[a,make_gini(new_attributes,childs_data,class,level+1,16*(column-1)+possibles)];
          %  end
        end
    end
    o=[level,column,attributes(max_index),-10];
    outs=[o,next];
    return
end