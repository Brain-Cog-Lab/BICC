function setGlobalOpts()
%SETGLOBALX 此处显示有关此函数的摘要
%   此处显示详细说明
global Opts
Opts.C = 3/200;
Opts.alpha = -0.0035;
Opts.beta = 0.35;
Opts.gamma = -0.55;
Opts.Factor_K = 8;

Opts.W_GC_PU = [2.5; 2.5; -80];
Opts.K = [0.1; 0; 0.1];
Opts.Wmask_PU = [1; 0; 0];
Opts.Wmask = [1; 0; 1];
end

