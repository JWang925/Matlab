clear all
tic%For timing

%Initialize A/B's strategy
%AStrat=zeros(2,13); BStrat=zeros(2,13);
% AStrat=[0.454 0.443 0.254 0 0 0 0 0.422 0.549 0.598 0.615 0.628 0.641;
%         0 0 0.169 0.269 0.429 0.610 0.760 1 1 1 1 1 1];
AStrat=[1 1 0 0 0 0 0 1 1 1 1 1 1;
        0 0 0 0 0 0 1 0 0 0 0 0 0];
    
BStrat=[1 1 0 0 0 0 0 1 1 1 1 1 1;
        0 0 0 0.251 0.408 0.583 0.759 1 1 1 1 1 1];    

%Initialize A/B's bank
ACash=0; BCash=0;
ACashHisto=0;BCashHisto=0;


%Game setting
nSim=15*10^6; %number of total games

%for iSim=1:nSim
parfor iSim=1:nSim
    bet=1;pot=2;Abet=0;Bbet=0;ifmatchbet=0;
    
    %Take the ante off each player
    ACash=ACash-1; BCash=BCash-1;
    
    %Deal a card to a and b by random
    Card=1+randperm(13,2);
    ACard=Card(1);BCard=Card(2);
    %clear Card %Clear might interfere with parfor

    %First betting round
    if(rand()<=AStrat(1,ACard-1)) %If A wants to bet
        Abet=1; %He bets one
        ACash=ACash-1;
        pot=pot+1;
        ifmatchbet=0;
        if(rand()<=BStrat(2,BCard-1)) %True if B wants to call
            Bbet=1;
            BCash=BCash-1;
            pot=pot+1;
            ifmatchbet=1;
        else
            ACash=ACash+pot;
        end
        
    else %If A checks
        if(rand()<=BStrat(1,BCard-1)) %True if B wants to bet
            Bbet=1;
            BCash=BCash-1;
            pot=pot+1;
            ifmatchbet=0;
            if(rand()<=AStrat(2,BCard-1)) %True if A wants to call
                Abet=1;
                ACash=ACash-1;
                pot=pot+1;
                ifmatchbet=1;
            else
               ifmatchbet=0;
               BCash=BCash+pot;
            end
        else %If b checks
            ifmatchbet=1;
        end
    end
        

    if(ifmatchbet==1) %True if we go to showdown
       if(ACard>BCard)
           ACash=ACash+pot;
       elseif(ACard<BCard)
           BCash=BCash+pot;
       else
           pause
       end     
    end
    
%   Cannot do this in a par-for because value ACash is a reduction variable
%   and is not useable within parfor
%     if(mod(iSim,10)==0)
%         ACashHisto=[ACashHisto,ACash];
%         BCashHisto=[BCashHisto,BCash];
%     end
end

% figure
% plot(ACashHisto,'color','r'); hold on;
% plot(BCashHisto,'color','b');
% legend('A','B');

AWinRate=ACash/nSim;
BWinRate=BCash/nSim;

toc%For timing
