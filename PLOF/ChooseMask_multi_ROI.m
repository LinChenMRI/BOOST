function [Mask] = ChooseMask_multi_ROI(image,savedir,MaskName,titleMessage,ROI_number,color_all)
% Mask:3D:x,y,ROI number
if nargin == 3
    titleMessage = 'Choose ROI';
end
mymkdir(savedir);
MaskName = [MaskName,'.mat'];

if exist([savedir,filesep,MaskName]) ~=0 % if the fid file exists?
    load([savedir,filesep,MaskName]);
    
    if exist('xindex_1','var') && exist('yindex_1','var')
        figure;imshow(abs(image),[],'InitialMagnification','fit');
        Mask_back = Mask;
        Mask = [];
        for mm = 1:ROI_number % loop over different ROIs
            eval(['Mask_',num2str(mm),'=','Mask_back(:,:,',num2str(mm),');']);
            eval(['xindex_',num2str(mm),'=','xindex_',num2str(mm),'/size(Mask_1,2)*size(image,2);']);
            eval(['yindex_',num2str(mm),'=','yindex_',num2str(mm),'/size(Mask_1,1)*size(image,1);']);
            eval(['Mask_',num2str(mm),'=','imresize(Mask_',num2str(mm),',size(image));']);
            eval(['Mask(:,:,',num2str(mm),')=Mask_',num2str(mm),';'])
            % plot the region in the image
            eval(['line(xindex_',num2str(mm),',yindex_',num2str(mm),',''Color'',color_all(',num2str(mm),',:),''LineWidth'',3.5);drawnow'])% eval语句内部如果有单引号，用两个单引号代替
        end
        
    end
else
    figure;imshow(abs(image),[],'InitialMagnification','fit');% plot M0 image
    for mm = 1:ROI_number % loop over different ROIs
    title([strrep(titleMessage,'_',' '),' ',num2str(mm)]);drawnow
    eval(['[Mask_',num2str(mm),',xindex_',num2str(mm),',yindex_',num2str(mm),'] = roipoly;']);% mutually choose
    eval(['Mask(:,:,',num2str(mm),')=Mask_',num2str(mm),';'])
    eval(['line(xindex_',num2str(mm),',yindex_',num2str(mm),',''Color'',color_all(',num2str(mm),',:),''LineWidth'',3.5);drawnow'])% eval语句内部如果有单引号，用两个单引号代替
    if mm==1
        eval(['save([savedir,filesep,MaskName],','''Mask'',','''xindex_',num2str(mm),''',''yindex_',num2str(mm),''');']);
    else
        eval(['save([savedir,filesep,MaskName],','''Mask'',','''xindex_',num2str(mm),''',''yindex_',num2str(mm),''',''-append'');']);
    end
    end
    SaveEps([savedir],strrep(MaskName,'.mat',''));
end
    
end