function [FitResult,FitParam]  =  PLOFCruveFitting(Image,Freq,Flag,FitParam,Mask)
if isempty(find(Freq>100)) == 0
    M0image = mean(Image(:,:,Freq>100),3);
    NormalizeImage = Image./repmat(M0image+eps,[1,1,size(Image,3)]);
else 
    NormalizeImage = Image;
end

Saturation  = squeeze(sum(sum(NormalizeImage.*repmat(Mask,[1,1,size(NormalizeImage,3)]),2),1)/sum(Mask(:)));

FitParam.ifshowimage = 1;
FitParam.name = [Flag,'_PLOF'];
[FitResult,FitParam] = PLOF(Freq,Saturation ,FitParam);

end