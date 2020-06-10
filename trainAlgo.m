function [ret,id]=trainAlgo(nDays)
    %Load data from current No Error
    datos=load('cWnE');
    datos=datos.ans;
    min2sim=nDays*24*60;%Cantidad de minutos para entrenarlo

    datos=fil(datos);
    datos=1000*datos;
    datos=(datos(:,2));

    %disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

    figure('Name','Modelo AR')
    datos2=datos(1:min2sim,:);

    AccDemand=cumsum(datos2);
    %calculate the accumulated demand
    %%% select y_actual to work
    y_actual = AccDemand;
    subplot(2,2,1)
    plot(y_actual)

    % split the total data into modeling  and validation data
    Ts=1; %minutes
    n = numel(y_actual);
    sampled_minutes=min2sim/8; % Number of minutes for identification and rest is for vaslidation

    %%Try several sampled_minutes
    ns = floor((sampled_minutes/n)*n); 
    y_id = y_actual(1:ns,:);
    y_v = y_actual((ns+1:end),:);
    data_id = iddata(y_id, [], Ts, 'TimeUnit', 'Min'); %data for modeling
    data_v  = iddata(y_v, [], Ts, 'TimeUnit', 'Min', 'Tstart', ns+1);%data for validation
    subplot(2,2,2)
    plot(data_id,data_v)
    legend('Modeling data','Validation data','location','Northwest')

    %%estimate model
    sys_Ord=1; % try different system orders
    sysAR=ar(data_id,sys_Ord);
    nstep = 50; % nsteps prediction horizon   
    subplot(2,2,3)
    compare(data_id,sysAR,nstep)
    %figure; compare(data_v,sysAR,nstep)  % comparison to validation data

    %%Predict every nsteps
    subplot(2,2,4)
    yp = predict(sysAR,[data_id;data_v],nstep);
    yp2=yp(ns+1:end);
    dif=data_v.y-yp.y(ns+1:end);
    plot(data_v,yp(ns+1:end));
    legend('Actual data','Predicted data','location','Northwest')
    datostrained=(diff(yp(ns+1:end)));
    id=(diff(yp(ns+1:end)));
    ret=datostrained;
    datostrained=datostrained.y;
end

function ret=fil(datos)
        ret=0;
        min=datos.Time;
        dat=datos.Data;
        ind=1;
        for i=1:size(min,1)
            if mod(min(i),1)==0
                ret(ind,1)=min(i);
                ret(ind,2)=dat(i);
                ind=ind+1;
            end
        end
end