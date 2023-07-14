function [Mask,xindex,yindex] = ChooseMask(image,savedir,MaskName,titleMessage)

if nargin == 3
    titleMessage = 'Choose ROI';
end
mymkdir(savedir);
MaskName = [MaskName,'.mat'];

if exist([savedir,filesep,MaskName]) ~=0 % if the fid file exists?
    load([savedir,filesep,MaskName]);
    if exist('xindex','var') && exist('yindex','var')
        xindex = xindex/size(Mask,2)*size(image,2);
        yindex = yindex/size(Mask,1)*size(image,1);
        Mask = imresize(Mask,size(image));
        Mask(Mask>0.5) = 1;
        Mask(Mask<=0.5) = 0;    
        figure;imshow(abs(image),[],'InitialMagnification','fit');
        line(xindex,yindex,'Color','r','LineWidth',3.5); drawnow % plot the region in the image
    end
else
    figure;imshow(abs(image),[],'InitialMagnification','fit');title(strrep(titleMessage,'_',' '));
    [Mask,xindex,yindex] = roipoly; % mutually choose
    line(xindex,yindex,'Color','r','LineWidth',3.5); drawnow % plot the region in the image
    save([savedir,filesep,MaskName],'Mask','xindex','yindex');
    SaveEps([savedir],strrep(MaskName,'.mat',''));
end
    
end