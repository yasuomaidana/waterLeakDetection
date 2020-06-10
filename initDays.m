%Initialites the days based on quantity of days
function initDays(nDays)
    t=60*24*nDays;
    datDay=days(nDays);
    
    %Saves the data generated into compatible simulink files
    savetoSim('twc',datDay,t)
    savetoSim('tshow',datDay,t)
    savetoSim('kit',datDay,t)
    savetoSim('food',datDay,t)
    savetoSim('other',datDay,t)
end

%Saves the data into a simulink's matlab compatible file
function savetoSim(name,daydat,t)
    dat=getT(daydat,t,name);
    save(name,'dat','-v7.3');
end

%Get time paremeters of a parameter and return into time serie
function tr=getT(ac,t,name) 
    trz=zeros(t+1,1);
    for d=1:size(ac,2)
        b=getfield(ac(d),name);
        for i=1:size(b,2)
            sH=getfield(b(i),'sH');
            sM=getfield(b(i),'sM');
            fH=getfield(b(i),'fH');
            fM=getfield(b(i),'fM');
            sT=sH*60+sM;
            fT=fH*60+fM;
            sT=sT+(d-1)*24*60;
            fT=fT+(d-1)*24*60;
            for j=1:fT-sT
                trz(j+sT)=1;
            end
        end
    end
    tr=timeseries(trz,'Name',name);
end

%Retunrs the days with consumtion
function rdys=days(Nd)
    
    Behaive=load('Behaive');
    for i=1:Nd
        dys(i)=ini_day(Behaive);
    end
    %%%%%%%%%%%Write%%%%%%%%%%%%%%%%%%%%
    if not(isfile('Days.mat'))
        dy=matfile('Days.mat','Writable',true);
    else
        dy=load('Days.mat');
    end
    dy=dys;
    rdys=dy;
    save('Days')
end

%Generates day behaivor
function day=ini_day(Behaive)
    Q=qUse();
    oU=randperm(3);
    
    [twc,tshow,kit,food,other]=init_Zones(Behaive,oU);
    
    [twc,tshow,kit,food,other]=parts(Behaive,Q,oU,twc,tshow,kit,food,other);
    
    day.twc=twc;
    day.tshow=tshow;
    day.kit=kit;
    day.food=food;
    day.other=other;
end

%Initializes daily zones
function [twc,tshow,kit,food,other]=init_Zones(Behaive,oU)
    zone='twc';
    twc=createZone(Behaive,zone,oU);
    zone='tshow';
    tshow=createZone(Behaive,zone,oU);
    zone='kit';
    kit=createZone(Behaive,zone,oU);
    zone='food';
    food=createZone(Behaive,zone,oU);
    zone='other';
    other=createZone(Behaive,zone,oU);
end

%Generates daily consumption per house zone
function [rtwc,rtshow,rkit,rfood,rother]=parts(Behaive,Q,oU,twc,tshow,kit,food,other)
    tq=fieldnames(Q);
    tn=fieldnames(Behaive.Member);
    for i1=1:size(tq,1)
        ind=2;
        name=char(tq(i1));
        name2=char(tn(i1));
        dat=getfield(Q,name);
        for i=2:dat
            v=1;
            while(v)
                [snH,snM]=randTime();
                at=getfield(Behaive.Member(oU(ind)),name2);
                [fnH,fnM]=sumtime(snH,snM,at);
                for ii=1:size(twc,2)
                    [sH,sM,fH,fM]=getwc(twc,ii);
                    v=validTime(sH,sM,fH,fM,snH,snM,fnH,fnM);
                end

            end
            
            if strcmp(name2,'tshow')
                tshow(i).sH=snH;
                tshow(i).sM=snM;
                tshow(i).fH=fnH;
                tshow(i).fM=fnM;
            end
            if strcmp(name2,'twc')
                twc(i).sH=snH;
                twc(i).sM=snM;
                twc(i).fH=fnH;
                twc(i).fM=fnM;
            end
            
            if strcmp(name2,'kit')
                kit(i).sH=snH;
                kit(i).sM=snM;
                kit(i).fH=fnH;
                kit(i).fM=fnM;
            end
            
            if strcmp(name2,'food')
                food(i).sH=snH;
                food(i).sM=snM;
                food(i).fH=fnH;
                food(i).fM=fnM;
            end
            
            if strcmp(name2,'other')
                other(i).sH=snH;
                other(i).sM=snM;
                other(i).fH=fnH;
                other(i).fM=fnM;
            end
            
            %twc=wtwc(snH,snM,fnH,fnM,i);
            ind=ind+1;
            if(ind>3)
                ind=1;
            end
        end
    end
    rtwc=twc;
    rtshow=tshow;
    rkit=kit;
    rfood=food;
    rother=other;
end

%Creates and initialize a zone
function retF= createZone(Behaive,zone,oU)
    ind=1;
    [sH,sM]=randTime(); %Generates random hour
    ti=getfield(Behaive.Member(oU(ind)),zone);
    %[fH,fM]=sumtime(sH,sM,Behaive.Member(oU(ind)).twc);
    [fH,fM]=sumtime(sH,sM,ti);
    retF(1).sH=sH;
    retF(1).sM=sM;
    retF(1).fH=fH;
    retF(1).fM=fM;
end

%Get start and finish H M from structure
function [sH,sM,fH,fM]=getwc(wc,i)
    sH=wc(i).sH;
    sM=wc(i).sM;
    fH=wc(i).fH;
    fM=wc(i).fM;
end

%Generates a random hour with minutes
function [rH,rM]=randTime()
    rH=randi([0 23]);
    rM=randi([0 59]);
end

%Validates if the range time is correct
function valid=validTime(soH,soM,foH,foM,snH,snM,fnH,fnM)
    valid=0;
    sO=soH*60+soM;
    fO=foH*60+foM;
    sN=snH*60+snM;
    fN=fnH*60+fnM;
    if ((sN>=sO) && (sN<=fO))
        valid=1;
    end
    if ((fN>=sO) && (fN<=fO))
        valid=1;
    end
end

%Returns the end hour with end minute
function [lH,lM]=sumtime(h,m,ti)
    lM=m+ti;
    lH=h;
    if lM>=60
        lM=lM-60;
        lH=lH+1;
    end
end

%Gives the quantities of uses of each element for the day
function qU=qUse()
    qU.wc=sumU(1,4);
    qU.show=sumU(0,2);  
    qU.kit=sumU(0,3);
    qU.food=sumU(0,3);
    qU.other=sumU(0,5); 
end

%Sum uses
function sm=sumU(l,u)
    sm=0;
    for i=1:3
        sm=randi([l u])+sm;
    end
end