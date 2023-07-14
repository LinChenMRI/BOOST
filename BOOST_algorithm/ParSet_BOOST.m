function  [par] = ParSet_BOOST(nSig,Noisy_CEST_image)
% Parameter setting for BOOST
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!
% Pay attention: the noiselevel (par.nSig) and the subspace dimension
% (par.k_subspace) play significant roles in BOOST denoising. You can
% modify the two parameters by yourself if you're not satified with the
% automatical outcome.
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!

% par.k_subspace  : the remained subspace dimension. A higher value means stronger spectral low rank constraint
% par.nSig        : the noise level of the noisy CEST images. A higher value means stronger regularization

% other parameters can also be modified if you like

%% Patch-based Iteration Parameters
% for NLLR approximation
par.nSig        =   nSig*255;                          % Variance of the noise image
par.SearchWin   =   30;                                % Non-local patch searching window
par.c1          =   4.5*sqrt(2);                       % Constant num for CEST images
par.step        =   3;                                 % Stepsize for key patch selecting
par.patnum      =   100;                               % The number of patches in each nonlocal group
par.patsize     =   5;                                 % The size of patch (D*D)  
% regularization parameters
par.rho         =   20;
par.belta       =   1;
par.lambda      =   0.8;
par.alpha       =   10;
par.kappa       =   0.5;
par.lamada      =   0.54;
% loop
par.Innerloop_X   =   10;                              % The number of inner loops (ADMM)
par.Iter          =   10;                              % The number of outer loops (AM)
% subspace dimension
% SVD here to determine the k value
[Height, Width, Band]  = size(Noisy_CEST_image);  
NN = Height*Width;
Y = reshape(Noisy_CEST_image, NN, Band)';
s= svd(Y,'econ');%
% median criterian
d = s.^2;
D = diag(d);
k_set = find(sqrt(diag(D)) >= 1.06*sqrt(median(d(sqrt(diag(D)) < 2*median(sqrt(diag(D)))))),1,'last');
par.k_subspace = k_set;
end