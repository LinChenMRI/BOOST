function [DeltaZmap,Rmap] = PLOFMapFitting(Image,Freq,FitParam,Mask,T1map)
Image(isnan(Image)) = 0;
if isempty(find(Freq>100)) == 0
    M0image = mean(Image(:,:,Freq>100),3);
    NormalizeImage = Image./repmat(M0image+eps,[1,1,size(Image,3)]);
else
    NormalizeImage = Image;
end


Rmap = zeros(size(Mask));
DeltaZmap =  zeros(size(Mask));
h = waitbar(0,'Please wait...');
count = 1;
FitParam.ifshowimage = 0;

for xindex = 1:1:size(Mask,1)
    for yindex = 1:1:size(Mask,2)
        if Mask(xindex,yindex) == 1
            FitParam.R1 = 1/T1map(xindex,yindex);
            Saturation = squeeze(NormalizeImage(xindex,yindex,:));
            [FitResult,FitParam] = PLOF(Freq,Saturation,FitParam);
            Rmap(xindex,yindex) = FitResult.Rpeak;
            DeltaZmap(xindex,yindex) = FitResult.DeltaZpeak;
            waitbar(count/sum(Mask(:)),h);
            count = count+1;
        end
    end
end
delete(h);
end


function c = mycolorbar()
    c = colorbar('FontSize',23,'linewidth',1.5,'FontName','Arial','fontweight','b');
end