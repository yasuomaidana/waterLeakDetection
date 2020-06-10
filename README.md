# waterLeakDetection
This is a Matlab program that simulates the water consumption of a mexican house of 3 members. In this model we introduce an error then using a machine learning algorithm we predict if there exist a leak

To execute this program you need the following packages
1. Simulink
2. Simscape
3. A version of matlab that supports appdesigner

To run this project please open from matlab 'Interface.mlapp'
Then from app designer run the program.
After that you will see an interface that allows you to run a previous 
simulation or if you desire run a new one
It is important to say that for several days it could take some time
for 7 days of simulation with my computer Lenovo ideapad320 from 2017
it takes around 14 minutes to complete, if your computer has more power
it shouldn't be a problem

NOTE: If your matlab version NOT SUPPORT appdesigner or if you want 
to execute manually the program, to do this you need to do the 
following instruction
Run
[fug,info]=worktest(ndays,simulate,train,MB,PB,MS,PS)
where
    Outputs
fug=a boolean that says if you have a leak
info=information of the leak
    Inputs
ndays=Integer that says the number of days to be simulate
simulate=A boolean that activate the simulation (1) or that load a previous simulation (0)
train=Integer that says the number of days used to train the model (it must be less than ndays)
MB=Magnitude of big leak (it control the area of aperture of the leak)
PB=Probability of that the big leak occurs
MS=Magnitude of big leak (it control the percentage of nominal aperture per house's element)
PB=Probability of MS occurs (per each element)
