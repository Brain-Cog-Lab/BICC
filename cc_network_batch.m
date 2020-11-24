function [V_Sn, V_Rn, dW, dK]= cc_network_batch(S, W, V_S, V_R, PU, PUmask, Opts)
C = Opts.C;
alpha = Opts.alpha;
beta = Opts.beta;
gamma = Opts.gamma;

W_PU_IPN = -1;
V_Sn =  -C .* (V_S - S) + V_S;   
if PUmask == 1
    Sf = tanh(V_Sn*W + PU);
else
    Sf = tanh(V_Sn*W + PU*W_PU_IPN);
end

%Sf = tanh(V_Sn*W + PU*W_PU_IPN);
if Sf<0
	Sf = 0;
end
V_Rn = -C .* (V_R - Sf) + V_R;
V_Rn(V_Rn<0) = 0;

T1 = alpha .* (V_Sn' * V_Rn);
T2 = beta .* (V_Sn' * (V_Rn-V_R));
T3 = gamma .* ((V_Sn-V_S)' * V_Rn);

dW = T1 + T2 + T3;
dK = dW.*W;
end