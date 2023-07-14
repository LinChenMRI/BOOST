function [dx] = soft_vector_shrink(dx,Thresh)
%SHRINK2   Vectorial shrinkage (soft-threholding)
%   [dxnew,dynew] = SHRINK2(dx,dy,Thresh)
norm2 = norm(dx,2);


dx = (max(norm2 - Thresh,0))/(max(norm2 - Thresh,0)+Thresh).*dx;
end
