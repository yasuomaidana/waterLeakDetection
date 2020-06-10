%inizialites the House Behaivor
function initHouse()
    ini_Sim();
end

%Gives the behaivor of the members of the house and the house
function Bh=ini_Sim()
    if not(isfile('Behaive.mat'))
        Bh=matfile('Behaive.mat','Writable',true);
    else
        Bh=load('Behaive.mat');
    end
    beh=datBeh();
    wash=0;
    cle=0;
    for i=1:3
        %Assign gender to the member
        g=gender();
        %Asign the time that the member spends on each 
        Member(i).twc=round(normrnd(beh(g).wc.ave,beh(g).wc.std));
        Member(i).tshow=round(normrnd(beh(g).show.ave,beh(g).show.std));
        
        Member(i).kit=round(normrnd(beh(g).kit.ave,beh(g).kit.std));
        Member(i).food=round(normrnd(beh(g).food.ave,beh(g).food.std));
        
        Member(i).other=round(normrnd(beh(g).other.ave,beh(g).other.std));
        %Member(i).wash=round(normrnd(beh(g).wash.ave,beh(g).wash.std));
        washi=round(normrnd(beh(g).wash.ave,beh(g).wash.std));
        clei=Member(i).other+Member(i).food+washi;
        if clei>cle
            cle=clei;
            House.cleani=cle;
        end
        
        if washi>wash
            wash=washi;
            House.wash=wash;
        end
    end
    Bh.Members=Member;
    Bh.House=House;
    save('Behaive')
end

%Generates structure of consumption from data obtained
function behaive=datBeh()
    %Water consumption behaivor of mens
    behaive(1).wc.ave=16.33;
    behaive(1).wc.std=4.76;
    behaive(1).show.ave=47.6;
    behaive(1).show.std=14.08;
    behaive(1).wash.ave=11;
    behaive(1).wash.std=6.89;
    behaive(1).kit.ave=16.66;
    behaive(1).kit.std=4.80;
    behaive(1).food.ave=5.1;
    behaive(1).food.std=.98;
    behaive(1).other.ave=3.83;
    behaive(1).other.std=0.75;
    %Water consumption behaivor women
    behaive(2).wc.ave=16.33;
    behaive(2).wc.std=4.76;
    behaive(2).show.ave=47.6;
    behaive(2).show.std=14.08;
    behaive(2).wash.ave=11;
    behaive(2).wash.std=6.89;
    behaive(2).kit.ave=16.66;
    behaive(2).kit.std=4.80;
    behaive(2).food.ave=5.1;
    behaive(2).food.std=.98;
    behaive(2).other.ave=3.83;
    behaive(2).other.std=0.75;
end

%Assig gender 1=Men, 2=Women
%based on Inegi data where 50.7% are woman
function g=gender()
    g=2;
    if rand>.507
        g=1;
    end
end