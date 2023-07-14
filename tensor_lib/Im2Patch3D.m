
function  [Y]  =  Im2Patch3D( Video, par)
% get full band patches
patsize     = par.patsize; % 读取每个patch大小（比如6就是6*6）
if isfield(par,'Pstep')
    step   = par.Pstep;
else
    step   = 1;
end
% Calculate the total patch number:(dW-dw+1)*(dH-dh+1)
TotalPatNum = (floor((size(Video,1)-patsize)/step)+1)*(floor((size(Video,2)-patsize)/step)+1);                  %Total Patch Number in the image
Y           =   zeros(patsize*patsize, size(Video,3), TotalPatNum);                                       %Patches in the original noisy image
% Y is used to store all the FBPs in the whole MSI
k           =   0;


for i  = 1:patsize
    for j  = 1:patsize
        k     =  k+1;
        tempPatch     =  Video(i:step:end-patsize+i,j:step:end-patsize+j,:); % 
        Y_1(i,j,:,:,:) = tempPatch; % the 5D tensor to store all the FBPS 
        Y(k,:,:)      =  Unfold(tempPatch, size(tempPatch), 3);% 沿着第三维展开（破坏了图像维信息）
    end
end  %Estimated Local Noise Level
end
