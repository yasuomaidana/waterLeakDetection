%Generates the error values
%For small errors it is a percentage
%For huge errors it returns the valve area
function generateErrors(MG,PG,MS,PS)
    T=load('twc').dat.Time(size(load('twc').dat.Time),1);
    T=T(1);
    
    Error.Fatal=randErr(MG,PG,T,'FatalError');
    
    Error.Wc=randErr(MS,PS,T,'TwcE');
    
    Error.Show=randErr(MS,PS,T,'tshowE');
    
    Error.Food=randErr(MS,PS,T,'foodE');
    
    Error.Kitch=randErr(MS,PS,T,'kitE');
    
    Error.Other=randErr(MS,PS,T,'otherE');
    
    Error.Cleani=randErr(MS,PS,T,'cleaniE');
    
    Error.Wash=randErr(MS,PS,T,'washE');
    %Saves the error in a .mat to display
    save('ErrorFlags','Error')
end
function act=randErr(Mag,Prob,T,Name)
    ts=timeseries();
    trg=rand()*100;
    Mag=Mag/2;
    act=1;
    if trg>Prob
        ts=timeseries(zeros(T+1,1));
        act=0;
    else
        for i=0:T
            dat=abs(normrnd(Mag,sqrt(Mag)));
            if dat>Mag*2
                dat=Mag;
            end
            ts=addsample(ts,'Data',dat,'Time',i);
        end
    end
    save(Name,'ts','-v7.3');
end

function show()
    F=lo('FatalError');
    T1=lo('TwcE');
    T2=lo('tshowE');
    T3=lo('foodE');
    T4=lo('kitE');
    T5=lo('otherE');
    T6=lo('cleaniE');
    T7=lo('washE');
end
function a=lo(dat)
    a=load(dat).ts;
end