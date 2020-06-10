function initWeeks(nDays)
    t=60*24*nDays;
    r=Weeks(nDays);
    savetoSim('cleani',r,t)
    savetoSim('wash',r,t)
end

%Saves the data into a simulink's matlab compatible file
function savetoSim(name,weeksdat,t)
    dat=getT(weeksdat,t,name);
    save(name,'dat','-v7.3');
end

%Get time paremeters of a parameter and return into time serie
function tr=getT(ac,t,name)
    trz=zeros(t+1,1);
    for d=1:size(ac,2)
        b=getfield(ac(d),name);
        for i=1:size(b,2)
            sT=getfield(b(i),'S');
            fT=getfield(b(i),'E');
            for j=1:fT-sT
                trz(j+sT)=1;
            end
        end
    end
    tr=timeseries(trz,'Name',name);
end

function rwks=Weeks(Nd)
    
    
    wks=Week(Nd);
    %%%%%%%%%%%Write%%%%%%%%%%%%%%%%%%%%
    if not(isfile('Weeks.mat'))
        fwks=matfile('Weeks.mat','Writable',true);
    else
        fwks=load('Weeks.mat');
    end
    fwks=wks;
    rwks=fwks;
    save('Weeks','wks')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rw=Week(nDays)
    dat=load('Behaive').House; %Time used for clean and wash
    
    nWeeks=ceil(nDays/7);%Number of weeks to be simulated
    indcl=1;%Indexs for clean and wash
    indwa=1;
    
    %DAT
    tcl=dat.cleani;
    twa=dat.wash;
    %--
    rw.cleani(1).S=0;
    rw.cleani(1).E=0;
    rw.wash(1).S=0;
    rw.wash(1).E=0;
    
    for i=1:nWeeks
        
        q=QWeek(nDays,i);
        
        qc=q.cleani;
        
        for j=1:qc
            v=1;
            if indcl==1
                v=0;
                [st,et]=rndTi(i,nDays,tcl);
                rw.cleani(indcl).S=st;
                rw.cleani(indcl).E=et;
                indcl=indcl+1;
            else
                while(v)
                    [st,et]=rndTi(i,nDays,tcl);
                    rw.cleani(indcl).S=st;
                    rw.cleani(indcl).E=et;
                    v=validTime(rw.cleani);   
                end
                indcl=indcl+1;
            end
            
        end
        
        qw=q.wash;
        
        for j=1:qw
            v=1;
            if indwa==1
                v=0;
                [st,et]=rndTi(i,nDays,twa);
                rw.wash(indwa).S=st;
                rw.wash(indwa).E=et;
                indwa=indwa+1;
            else
                while(v)
                    [st,et]=rndTi(i,nDays,twa);
                    rw.wash(indwa).S=st;
                    rw.wash(indwa).E=et;
                    v=validTime(rw.wash);   
                end
                indwa=indwa+1;
            end
            
        end    
    end
    
end

%Creates wee behaivor of an element

%Validates that the time is not being used
%returns 1 if there exist a repetition
function v=validTime(item)
    v=0;
    li=size(item,2);
    for i=1:li-1
        if(item(li).S==item(i).E||item(li).E==item(i).E )
            v=1;
            break;
        end
    end
end

%Creates a random star-end time action
function [st,et]=rndTi(iw,nDays,tAc)
    ws=(iw-1);
    dysrm=nDays-ws*7;
    Srtw=ws*7*24*60;
    Ertw=iw*7*24*60;
    if(dysrm<7)
        Ertw=Srtw+dysrm*24*60;
    end
    st=randi([Srtw Ertw]);
    et=st+tAc;
    if(et>Ertw)
        et=Ertw;
    end
    if(et>nDays*24*60)
        et=nDays*24*60;
    end

end

%Generates the quantity per each activity per week
function qw=QWeek(nDays,iw)
    qw.cleani=randi([1 5]);
    qw.wash=randi([1 3]);
    if nDays<iw*7
        qw.cleani=QWE(1,5,nDays,iw);
        qw.wash=QWE(1,3,nDays,iw);
    end
end

%Generates pseudo aleatory quantity for the days remainders of the week
function qwe=QWE(l,u,nDays,iw)
    dysrm=nDays-(iw-1)*7;
    if(dysrm>u)
        qwe=randi([l u]);
    else
        qwe=randi([0 dysrm]);
    end
end