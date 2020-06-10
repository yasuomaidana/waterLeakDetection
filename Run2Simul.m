%It runs the simulation
function Run2Simul(ndays,MB,MS,PB,PS)
%simOut=sim('Simulation1_Simscape_Model',60*24)
%clc;
%clear;
warning('off');
%% Initialize values
model='Simulation5'; %Name of simulink-simscape model
%f=@()
initHouse();
%ex=timeit(f);
%ndays=input('How many days you want to simulate? :'); %Number of days that will be simulated 
simuTime=ndays*60*24; %Time of simulation in minutes

initDays(ndays);


initWeeks(ndays);


generateErrors(MB,MS,PB,PS);

%% Output section
runSim(model,simuTime);


%t=load('t');
%h=t.Time.h;
%plot(x1)

%%disp(runInf)
%%fprintf('----------Simulation finished----------\n')
end

%% This section enables me to run the simulink-simscape model
%runSim
%%%Outputs
%returns data from simulation in a dataset[retInfo]
%returns information about the simulation parameters [runInfo]
%%%Inputs
%name of simulink model [model] (string)
%time stop [stop_Time] (numeric value)
function [retInfo,runInfo,ou]=runSim(model,stop_Time)
    stp=num2str(stop_Time);
    simOut = sim(model,'SimulationMode','normal','AbsTol','1e-12',...
                'SaveState','on','StateSaveName','xout',...
                'SaveOutput','on','OutputSaveName','yout',...
     'SaveFormat', 'Dataset','StopTime',stp,'StartTime','0');
    outputs = simOut.get('xout');
    ou=simOut;
    retInfo=outputs;
    runInfo=simOut.getSimulationMetadata.ModelInfo;
end