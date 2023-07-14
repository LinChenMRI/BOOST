function PlotFitResult_3(FitResult,FitParam)

linecolors = lines(10);
Marker = {'-o','-v','-s','->','-*','-d','-^','-<','-p','-h','-x'};
figure;drawnow;
hold on
color_1 = [0,0,102]/256;
color_2 = [255,204,0]/256;
color_3 = [240,140,24]/256;

plot(FitResult.xindex,FitResult.Curve,'-','LineWidth',2.5,'MarkerSize',9,'Color',color_2);
plot(FitResult.xindex,FitResult.Background,'-','LineWidth',2.5,'MarkerSize',9,'Color',color_3);
plot(FitResult.Offset,FitResult.Saturation,'o','Color',color_1,'MarkerFaceColor',color_1,'MarkerSize',6);

axis([min(FitResult.Offset),max(FitResult.Offset),min(FitResult.Saturation)*0.98,max(FitResult.Saturation)*1.02]);
% axis([min(FitResult.Offset),max(FitResult.Offset),0.65,0.88]);
% axis([min(FitResult.Offset),max(FitResult.Offset),0.65,0.9]);
% axis([1.6,3.6,0.55,0.85]);
%  axis([1.05,3,0.62,0.9]);

maxSaturation = max(FitResult.Saturation);
minSaturation = min(FitResult.Saturation);
deltaSaturation = maxSaturation - minSaturation; 

ax = gca;
ax.XColor = 'black';
ax.YColor = 'black'; 

set(gca,'XDir','reverse');
set(gcf,'color','none');
box on
set (gcf,'Position',[100,100,420 360], 'color','w');
xlabel('Offset (ppm)','FontName','Times New Roman','FontSize',28,'fontweight','b');
ylabel('S/S0','FontName','Times New Roman','FontSize',28,'fontweight','b','Rotation',90);

legend('Fitting Curve','Fitting Background','Acquired Data','Location','SouthWest');
legend boxoff 
set(gca,'FontName','Times New Roman','FontSize',19.5,'fontweight','b','LineWidth',3,'GridLineStyle','--','TickDir','in');
hold off
end