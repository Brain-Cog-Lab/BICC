function [Wn, Kn] = update_batch(W, dW, Wmask, K, dK)
%Wn = W + dW.*Wmask.*abs(K);
Wn = W + dW.*Wmask.*K;
Kn = K + dK.*Wmask;