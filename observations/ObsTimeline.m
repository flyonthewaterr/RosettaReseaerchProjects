close all;clear;

%% setup  
% workpath = 'C:\Users\12605\Documents\MATLAB\Rosetta\Shape_dealing\';
% shapefile = [workpath,'67P_shape_model_2M.mat']; 
cspice_furnsh('C:/Users/12605/Documents/Rosetta/SPICE/Kernels/kernels/mk/ROS_OPS_V330_20200731_001.TM')
%%
target = '67P/C-G'; % ID of 67P
CGframe = '67P/C-G_CK'; % define the CG body-fixed coordinate system
camera = 'ROS_OSIRIS_NAC'; % name of the camera
format = 'ISOC' ;
prec = 3 ;

%% time tag  
% thermal analysis: cumulative insolation between 2014-05-17 and
% 2015-10-03
id = -365:366;
et = cspice_str2et('2015-08-13T02:03:00.0') + (-365:366)*86400; % intervals: day
xDtimestr = cspice_et2utc(et, format, prec ); % []
t = datetime(xDtimestr,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SSS');%HH:mm:ss.SSS

%%
% Initialize empty vectors for the distance and resolution values
d_sun = zeros(size(et)); % sun-comet distance
d_nac = zeros(size(et)); % NAC-comet distance
res_nac = zeros(size(et)); % NAC resolution
lat_sub = zeros(size(et)); % latitude of subsolar point

%%
[cam_pos, ~] = cspice_spkezr( camera, et, CGframe, 'CN+S', target);
d_nac = sqrt(sum((cam_pos(1:3,:)).^2,1));
for i = 1:size(et,2)
    sun_list(i,:) = sun_fun(et(i));
end
sun_km = sun_list(:,3)';
d_sun= cspice_convrt(sun_km, 'KM', 'AU');
lat_sub = sun_list(:,2)';


%% reslution
% Define pixel size in m
pxsize = 18.6e-6;

res_nac = d_nac * pxsize * 1000; % Res, m/px-1
%% save
DN = d_nac'; DS=d_sun';
LS = lat_sub'; RES=res_nac'; ID = id';
datacolumns = {'id','datet','dn','ds','ls','res'};
data = table(ID, t, DN, DS, LS, RES, 'VariableNames', datacolumns);

writetable(data, 'C:\Users\12605\Documents\Rosetta\Doc\Timeline\OBStimeline.csv'); 

%% not plotyyyy

% % Create a figure with two y-axes using yyaxis function
% figure
% 
% % Activate and plot into left side
% yyaxis left
% 
% % Plot sun-comet distance as a blue solid line
% % plot(et,d_sun,'b-')
% 
% % Hold on to plot more data on left side
% hold on
% 
% % Plot NAC-comet distance as a red dashed line
% plot(et,d_nac,'r--')
% 
% % Add ylabel for left side
% ylabel('Distance (km)')
% 
% % Release hold on left side
% % hold off
% 
% % Activate and plot into right side
% % yyaxis right
% 
% % Plot NAC resolution as a green dotted line
% % plot(et,res_nac,'g:')
% 
% % Hold on to plot more data on right side
% hold on
% 
% % Plot latitude of subsolar point as a magenta dash-dotted line
% plot(et,lat_sub,'m-.')
% 
% % Add ylabel for right side
% ylabel('Latitude (deg)') %Resolution (mrad) or 
% 
% % Release hold on right side
% hold off
% 
% % Add title and xlabel for the figure
% title('Plots with Different y-Scales')
% xlabel('Ephemeris time')

%% plotyyy
x1 = t; % e
y1 = d_nac;
y2 = d_sun;
y3 = lat_sub;
ylabels{1}='Space Distance (km)';
ylabels{2}='Solar Distance (AU)';
ylabels{3}='Subsolar Latitude (deg)';
[ax,hlines] = multiplotyyy({x1,y1},{x1,y2},{x1,y3},ylabels); % legend(cat(1,hlines{:}),'a','b','c','location','w')
xtickformat("yy-MM") % MMMM/d/yy

%gray bg, red line, black sticks
xline(t(454),'-.','Perihelion'); %,'LineWidth',1,'FontSize',13,'FontName','Trebuchet MS'
% xlabel('Time')
% ylabel('Comet center distance [km]')
% xtickangle(135)
% xlim([datetime("2015-04-15") datetime("2016-02-09")])

%%

%%

function sun_info = sun_fun(et)
target = '67P/C-G'; % ID of 67P
CGframe = '67P/C-G_CK'; % define the CG body-fixed coordinate system
% camera = 'ROS_OSIRIS_NAC'; % name of the camera
[state_sun, ~] = cspice_spkezr( 'Sun', et, CGframe, 'CN+S', target);
sun_dis = sqrt(sum((state_sun(1:3)).^2,1));
[sunp, ~, ~] = cspice_subslr( 'Intercept/DSK/Unprioritized', target, et, CGframe, 'CN+S', target );
[sunlon,sunlat] = sunrec2lat(sunp);
sun_info = [sunlon,sunlat,sun_dis];
end

function [sunlon,sunlat] = sunrec2lat(sunp)
[sunlon,sunlat] = cart2sph(sunp(1),sunp(2),sunp(3));
sunlon = sunlon/pi*180;
sunlat = sunlat/pi*180;
if sunlon < 0, sunlon = sunlon + 360; end

end