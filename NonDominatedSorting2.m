function [pop,F]=NonDominatedSorting2(pop,option)
    if nargin<2; option='min';end
%pop ro ezafe kardam ke betonam moghayese konam vali akhar sar aslan niaz
%nist be nazaram
    F=[];
    %index gozari mikonam ta khar sar betonam dorost bareshon daram

    for i=1:size(pop(:,1))
        pop(i).Index=i;
    end
    existPop=pop;%%% dar marhale aval faghat in doroste badesh bayad km she
    paretoFrontIndex=1;
    while( numel(existPop)>0)  
        F{paretoFrontIndex}=[];%#ok
        CurrentFront=F{paretoFrontIndex};
        for currentPopIndex=[existPop.Index];
           currentPop=existPop([existPop.Index]==currentPopIndex); %for test show current
           currentPopDominated=0;
            for currentInFront=CurrentFront;
                if Dominates2(currentInFront,currentPop,option)
                    currentPopDominated=1;
                    continue; %% agar azaye jebhe bar ozve ghalbe kard ke mirim soraghe ozve badi vali ehtemalan biad birone halghe gir kone pas bayad ye motaghayer bezaram ke vase kontorle yani az 2 ta halghe hamzaman kharej she
                %% onayii ro ke ghalebe kardaro peyda o hazf mikonim va dar akhar khodesho ezafe mikonim
                elseif Dominates2(currentPop,currentInFront,option);
                    deleteDominatedIndex=currentInFront.Index ;%%yaftan ozvi ke bayad hazf shavad
                    CurrentFront([CurrentFront.Index]==deleteDominatedIndex)=[] ;% hazf shodane ozvi ke bayad hazf shavad
                end
            end
            if currentPopDominated==1,continue;end
            CurrentFront=[CurrentFront currentPop]; %#ok %in bakhshe ezafe kardan
        end
        %ezafe kardan be front
        F{paretoFrontIndex}=CurrentFront; %#ok  
        paretoFrontIndex=paretoFrontIndex+1;%%bayad havasam bashe ke ye vaght khali nabashe ke akhar sar ye parto khali bemone ro dastam ke vase hazfesh moshkel bokhoram
        %%% kodi ke front tashkil shodaro tashkil bede
        %hazf kasayie ke be parto ezafe shodan
        for deleteInFront=CurrentFront
            deleteInFrontIndex=deleteInFront.Index;
           existPop([existPop.Index]==deleteInFrontIndex)=[];
        end 
    end
    %%ye eshtebahi dashtam ke F haro kamel bar midashtam  
     Q=F;
     F=[];
     for i=1:length(Q)
         F{i}= [Q{i}.Index];%#ok
         for k=  F{i}
             pop(k).Rank=i;
         end
     end
end