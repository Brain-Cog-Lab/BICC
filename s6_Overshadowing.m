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
W_CS1 = [0; 2.5; 0];
K = Opts.K;
V_S = [0, 0, 0];
V_R = 0;
Wmask = Opts.Wmask;

CS_Start = 1;
CS_End = CS_Start+200;
US_Start = 201;
US_End = US_Start+200;

Num_Normal = 20;
Num_Overshadowing = 20;
PL = [];

% Normal
for i = 1:Num_Normal
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
    W_CS1 = [W_CS1,W];
end

% Normal CS2
W = [0; 2.5; 0];
W_CS2 = [0; 2.5; 0];
K = Opts.K;
V_S = [0, 0, 0];
V_R = 0;

for i = 1:Num_Normal
    dW_GC_PU = [0; 0; 0];
    dK_GC_PU = [0; 0; 0];
    dW = [0; 0; 0];
    dK = [0; 0; 0];
    for t= 1:1500
        S_GC_PU = [0, 0, 0];
        S = [0, 0, 0];
        V_PU_Self = 0;
        if t>CS_Start && t<CS_End
            S(3) = 1; % PN -> IPN
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
    W_CS2 = [W_CS2,W];
end


% Overshadowing
W = [0; 2.5; 0];
Wlist = [0; 2.5; 0];
K = Opts.K;
V_S = [0, 0, 0];
V_R = 0;

for i = 1:Num_Overshadowing
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
            S(3) = 1;
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

figure
X = [0:size(Wlist,2)-1];
plot(X,Wlist(1,:),'k-','LineWidth',2);
hold on;
plot(X,Wlist(3,:),'k-','LineWidth',2);
hold on;
plot(X,W_CS1(1,:),'k--','LineWidth',2);
hold on;
plot(X,W_CS2(3,:),'k--','LineWidth',2);
legend('WO_{R,CS1}','WO_{R,CS2}','WN_{R,CS1}','WN_{R,CS2}');
axis([0 size(Wlist,2)-1 -0.1 2.5]); 
set(gca,'ytick',0:0.5:2.5,'fontsize',14)
xlabel('Number of Trials','fontsize',18);
ylabel('Weight','fontsize',18);
