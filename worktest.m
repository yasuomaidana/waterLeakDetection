function [fug,info]=worktest(ndays,simulate,train,MB,MS,PB,PS)
    close all
    SimInfo.Nd=ndays;
    SimInfo.Td=train;
    SimInfo.MB=MB;
    SimInfo.MS=MS;
    SimInfo.PB=PB;
    SimInfo.PS=PS;
    info='';
    save('SimInfo','SimInfo');
    if (simulate)
        Run2Simul(ndays,MB,MS,PB,PS); %Simscape 
    end
    %Acumulated waste no error
    acumNoError=load('aWnE').ans;
    %Current waste no error
    currNoError=load('cWnE').ans;
    acum=load('aW').ans;
    %Current waste no error
    curr=load('cW').ans;
    %Assign format
    acumNoError=assiFormat(acumNoError,'HH:MM','');
    currNoError=assiFormat(currNoError,'HH:MM','');
    acum=assiFormat(acum,'HH:MM','');
    curr=assiFormat(curr,'HH:MM','');
    
    semana=0;
    
    %Show per day
    for i=1:ndays
        figure(1);
        %Graphs daily current waste
        gcuD=getPerTime(currNoError,i-1,1);
        gcu=getPerTime(curr,i-1,1);
        subplot(2,2,1)
        plot(gcuD,'b'); %suppose to plot the position of the vector%
        hold on
        plot(gcu,'r'); %suppose to plot the position of the vector%
        legend('Current with no Error','Current with Errors')
        title('Current daily waste')
        hold off
        
        %Graphs per week
        if mod(i,7)==0&&i~=0
            semana=1+semana;
            hold off
        end
        gacD=getPerTime(acumNoError,semana*7,i-semana*7);
        gac=getPerTime(acum,semana*7,i-semana*7);
        subplot(2,2,2)
        plot(gacD,'b'); %suppose to plot the position of the vector%
        hold on
        plot(gac,'r'); %suppose to plot the position of the vector%
        legend('Accumulated with no Error','Accumulated with Error')
        title('Acumulated week waste')
        if mod(i,7)==0&&i~=0
            hold off
        else
            hold on
        end
        
        %Graphs current until now
        gcuT=getPerTime(currNoError,0,i);
        gcuT2=getPerTime(curr,0,i);
        subplot(2,2,3)
        plot(gcuT,'b'); %suppose to plot the position of the vector%
        hold on
        plot(gcuT2,'r'); %suppose to plot the position of the vector%
        legend('Current with no Error','Current with Error')
        title('Current waste')
        hold on 
        %Graphs accumulated until now
        gacT=getPerTime(acumNoError,0,i);
        gacT2=getPerTime(acum,0,i);
        subplot(2,2,4)
        plot(gacT,'b'); %suppose to plot the position of the vector%
        hold on
        plot(gacT2,'r'); %suppose to plot the position of the vector%
        legend('Accumulated with no Error','Accumulated with Error')
        title('Accumulated waste')
        hold on

        drawnow;
        if i==train
            [ret,id]=trainAlgo(1);
        end
        if i>train
            sendCu=getPerTime(curr,i-7,7);
            [fug,info]=detectF(sendCu,ret,id);
            if fug
                info=strcat('A leak was detected at :',info);
            end
        end
    end
    msgbox('Simulation finished, return to interface to see the results');
end