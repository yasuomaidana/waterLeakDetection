function prr()
    ndays=14;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Algorithm prediction application 
    %and show data


    %Acumulated waste no error
    acumNoError=load('aWnE').ans;
    %Current waste no error
    currNoError=load('cWnE').ans;

    %Se asigna formato
    acumNoError=assiFormat(acumNoError,'HH:MM','');
    currNoError=assiFormat(currNoError,'HH:MM','');

    %figure(1)
    %plot(acumNoError)
    %figure(2)
    %plot(currNoError)



    %SerieDatos
    semana=0;

    tic;
    figure(1).Name='Simulation results';
    
    %Hace un barrido por dia
    for i=1:ndays
        figure(1);
        %Graphs daily current waste
        gcuD=getPerTime(currNoError,i-1,1);
        subplot(2,2,1)
        
        plot(gcuD,'b'); %suppose to plot the position of the vector%
        legend('Current with no Error')
        title('Current daily waste')

        %Graphs per week
        if mod(i,7)==0&&i~=0
            semana=1+semana;
        end
        gacD=getPerTime(acumNoError,semana*7,i-semana*7);
        subplot(2,2,2)
        plot(gacD,'b'); %suppose to plot the position of the vector%
        legend('Accumulated with no Error')
        title('Acumulated week waste')


        %Graphs current until now
        gcuT=getPerTime(currNoError,0,i);
        subplot(2,2,3)
        plot(gcuT,'b'); %suppose to plot the position of the vector%
        legend('Current with no Error')
        title('Current waste')
        %hold on;

        %Graphs accumulated until now
        gacT=getPerTime(acumNoError,0,i);
        subplot(2,2,4)
        plot(gacT,'b'); %suppose to plot the position of the vector%
        legend('Accumulated with no Error')
        title('Accumulated waste')
        %hold on;


        drawnow;

        if i>=7
            sendCu=getPerTime(currNoError,i-7,7);
            sendAc=getPerTime(acumNoError,i-7,7);
            %Info a enviar a RunAlgo

        end
    end

    disp('Simulation finished')
end