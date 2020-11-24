clear;clc;
close all;
setGlobalOpts()
global Opts

W_GC_PU = Opts.W_GC_PU;
Wlist_GC_PU = [];
K_GC_PU = Opts.K;
V_GC_PU = [0, 0, 0];
V_PU = 1;
V_PU_Self_V = V_PU;
Wmask_PU = Opts.Wmask_PU;

W = [0; 2.5; 0];
Wlist = [];
K = Opts.K;
V_S = [0, 0, 0];
V_R = 0;
Wmask = Opts.Wmask;

CS_Start = 1;
CS_End = CS_Start+200;
US_Start = 201;
US_End = US_Start+200;

Num_Acquisition = 25;
Num_Extinction = 50;
Num_Reacquisition = 15;
PL = [];
% Acquisition
for i = 1:Num_Acquisition
    dW_GC_PU = [0; 0; 0];
    dK_GC_PU = [0; 0; 0];
    dW = [0; 0; 0];
    dK = [0; 0; 0];
    for t= 1:1500
        S_GC_PU = [0, 0, 0];
        S = [0, 0, 0];
        V_PU_Self = 0;
        if t>CS_Start && t<CS_End
            S(1) = 1; % PN -> IPN
            S_GC_PU(1) = 1; % GC -> PU
            S_GC_PU(3) = 1; % Int.N -> PU
            V_PU_Self = V_PU_Self_V; 
        end

        if t>US_Start && t<US_End
           S(2) = 1; % IO -> IPN
           S_GC_PU(2) = 1; % IO -> PU
           V_PU_Self = V_PU_Self_V;
        end
        
        % GC-PU
        PUmask = 1;
        [V_GC_PU, V_PU, ddW_GC_PU, ddK_GC_PU] = cc_network_batch(S_GC_PU, W_GC_PU, V_GC_PU, V_PU, V_PU_Self, PUmask, Opts);
        dW_GC_PU = dW_GC_PU + ddW_GC_PU;
        dK_GC_PU = dK_GC_PU + Opts.Factor_K.*ddK_GC_PU;
        % PN-IPN
        PUmask = 0;
        [V_S, V_R, ddW, ddK] = cc_network_batch(S, W, V_S, V_R, V_PU, PUmask, Opts);
        dW = dW + ddW;
        dK = dK + Opts.Factor_K.*ddK;
        PL = [PL,V_PU];
    end
    [W_GC_PU, K_GC_PU] = update_batch(W_GC_PU, dW_GC_PU, Wmask_PU, K_GC_PU, dK_GC_PU);
    Wlist_GC_PU = [Wlist_GC_PU,W_GC_PU];
    
    [W, K] = update_batch(W, dW, Wmask, K, dK);
    Wlist = [Wlist,W];
end

% Extinction
for i = 1:Num_Extinction
    dW_GC_PU = [0; 0; 0];
    dK_GC_PU = [0; 0; 0];
    dW = [0; 0; 0];
    dK = [0; 0; 0];
    for t= 1:1500
        S_GC_PU = [0, 0, 0];
        S = [0, 0, 0];
        V_PU_Self = 0;
        if t>CS_Start && t<CS_End
            S(1) = 1; % PN -> IPN
            S_GC_PU(1) = 1; % GC -> PU
            S_GC_PU(3) = 1; % Int.N -> PU
            V_PU_Self = V_PU_Self_V;
        end

        if t>US_Start && t<US_End
           S(2) = 0; % IO -> IPN
           S_GC_PU(2) = 0; % IO -> PU
           V_PU_Self = V_PU_Self_V;
        end
        
        % GC-PU
        PUmask = 1;
        [V_GC_PU, V_PU, ddW_GC_PU, ddK_GC_PU] = cc_network_batch(S_GC_PU, W_GC_PU, V_GC_PU, V_PU, V_PU_Self, PUmask, Opts);
        dW_GC_PU = dW_GC_PU + ddW_GC_PU;
        dK_GC_PU = dK_GC_PU + Opts.Factor_K.*ddK_GC_PU;
        
        % PN-IPN
        PUmask = 0;
        [V_S, V_R, ddW, ddK] = cc_network_batch(S, W, V_S, V_R, V_PU, PUmask, Opts);
        dW = dW + ddW;
        dK = dK + Opts.Factor_K.*ddK;
        PL = [PL,V_PU];
    end
    [W_GC_PU, K_GC_PU] = update_batch(W_GC_PU, dW_GC_PU, Wmask_PU, K_GC_PU, dK_GC_PU);
    Wlist_GC_PU = [Wlist_GC_PU,W_GC_PU];
    
    [W, K] = update_batch(W, dW, Wmask, K, dK);
    Wlist = [Wlist,W];
end

% Reacquisition
for i = 1:Num_Reacquisition
    dW_GC_PU = [0; 0; 0];
    dK_GC_PU = [0; 0; 0];
    dW = [0; 0; 0];
    dK = [0; 0; 0];
    for t= 1:1500
        S_GC_PU = [0, 0, 0];
        S = [0, 0, 0];
        V_PU_Self = 0;
        if t>CS_Start && t<CS_End
            S(1) = 1; % PN -> IPN
            S_GC_PU(1) = 1; % GC -> PU
            S_GC_PU(3) = 1; % Int.N -> PU
            V_PU_Self = V_PU_Self_V;
        end

        if t>US_Start && t<US_End
           S(2) = 1; % IO -> IPN
           S_GC_PU(2) = 1; % IO -> PU
           V_PU_Self = V_PU_Self_V;
        end
        
        % GC-PU
        PUmask = 1;
        [V_GC_PU, V_PU, ddW_GC_PU, ddK_GC_PU] = cc_network_batch(S_GC_PU, W_GC_PU, V_GC_PU, V_PU, V_PU_Self, PUmask, Opts);
        dW_GC_PU = dW_GC_PU + ddW_GC_PU;
        dK_GC_PU = dK_GC_PU + Opts.Factor_K.*ddK_GC_PU;
        
        % PN-IPN
        PUmask = 0;
        [V_S, V_R, ddW, ddK] = cc_network_batch(S, W, V_S, V_R, V_PU, PUmask, Opts);
        dW = dW + ddW;
        dK = dK + Opts.Factor_K.*ddK;
        PL = [PL,V_PU];
    end
    [W_GC_PU, K_GC_PU] = update_batch(W_GC_PU, dW_GC_PU, Wmask_PU, K_GC_PU, dK_GC_PU);
    Wlist_GC_PU = [Wlist_GC_PU,W_GC_PU];
    
    [W, K] = update_batch(W, dW, Wmask, K, dK);
    Wlist = [Wlist,W];
end

figure;
plot([1:Num_Acquisition], Wlist(1,1:Num_Acquisition),'k-');
hold on;
plot([Num_Acquisition:Num_Acquisition+Num_Extinction], Wlist(1,Num_Acquisition:Num_Acquisition+Num_Extinction),'k--');
hold on;
plot([Num_Acquisition+Num_Extinction:Num_Acquisition+Num_Extinction+Num_Reacquisition], Wlist(1,Num_Acquisition+Num_Extinction:end),'k-.');
hold on;
xlabel('Number of Trials','fontsize',12);
ylabel('Weight','fontsize',12);
legend({'W_{Acquisition}','W_{Extinction}','W_{Reacquisition}'},'FontSize',12);