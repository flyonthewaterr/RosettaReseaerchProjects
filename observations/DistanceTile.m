%%
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

%% perihelion forwards 6months backwards 6months
perihelion_t = '2015-08-13T02:03:00.0';
perihelio_et = cspice_str2et(perihelion_t);
%%
i = -120: 1 :180;
time = perihelio_et + i*60*60*24; % intervals: day
time_F = time(1:152);% ver:1:155
[cam_pos_F, ~] = cspice_spkezr( camera, time_F, CGframe, 'CN+S', target);
D_F = sqrt(sum((cam_pos_F(1:3,:)).^2,1));
xDtimestr_F = cspice_et2utc( time_F, format, prec );%
t_F = datetime(xDtimestr_F,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SSS');%HH:mm:ss.SSS...

%%
time_L = time(185:301);% ver:185:301
[cam_pos_L, ~] = cspice_spkezr( camera, time_L, CGframe, 'CN+S', target);
D_L = sqrt(sum((cam_pos_L(1:3,:)).^2,1));
xDtimestr_L = cspice_et2utc( time_L, format, prec );%
t_L = datetime(xDtimestr_L,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SSS');%HH:mm:ss.SSS...

%%
i_M = 0: 1 :(32*24);
M_et = time(152);
time_M = M_et + i_M*60*60; % intervals: hour
[cam_pos_M, ~] = cspice_spkezr( camera, time_M, CGframe, 'CN+S', target);
D_M = sqrt(sum((cam_pos_M(1:3,:)).^2,1));
xDtimestr_M = cspice_et2utc( time_M, format, prec );%[]
t_M = datetime(xDtimestr_M,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SSS');%HH:mm:ss.SSS...
%%
UTC_PO = datetime(UTC_list,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SSS');

%% 

t = tiledlayout(1,4,'TileSpacing','none');
ax1 = nexttile;
plot(t_F',D_F,"Color","#A2142F",'LineWidth',2) %#D95319
xline(t_F(121),'-.','Perihelion','LineWidth',2,'FontSize',13);%,'FontName','Trebuchet MS'
ax1.YAxisLocation = 'left';
ax1.YTick = [0,200,400,600,800,1000,1200,1400,1600];

xtickformat("yy-MM")%-ddyy

ax1.Box = 'off';
xlim([datetime("2015-04-15") datetime('2015-09-13 02:03:00')])
ylim([0 1600])
xtickangle(45)
hold on
scatter(UTC_PO(1),SCD(1),80,'MarkerEdgeColor',"#0072BD",...
              'MarkerFaceColor',"#D95319",...
              'LineWidth',1.5)

          ax2 = nexttile([1 2]);
ax2.YTick = [];
% ax2.YColor = 'w';
plot(t_M',D_M, "Color","#A2142F",'LineWidth',2)
xline(t_M(505),'--','1.39au','LineWidth',2,'FontSize',13);%,'FontName','Trebuchet MS'481
xtickformat("yy-MM-dd")%yy
xlim([datetime('2015-09-14 02:03:00') datetime('2015-10-15 02:03:00')])
xtickangle(45)
ylim([0 1600])
ax2.YAxis.Visible = 'off';
set (ax2,'color','#DAE3F3');
ax2.Box = 'off';
hold on
scatter(UTC_PO(2),SCD(2),80,'MarkerEdgeColor',"#0072BD",...
              'MarkerFaceColor',"#D95319",...
              'LineWidth',1.5)
scatter(UTC_PO([8 9 10]),SCD([8 9 10]),80,"square",'MarkerEdgeColor',"#0072BD",...
              'MarkerFaceColor',"#D95319",...
              'LineWidth',1.5)
xlabel('Rosetta-Comet distance [km]','FontSize',14,'FontWeight','bold')
ax3 = nexttile;
plot(t_L',D_L, "Color","#A2142F",'LineWidth',2)
% yticks([200,400,600,800,1000,1200,1400,1600])
% ax3.YTick = [0,1400];
% yticks([])
xtickformat("yy-MM")%-ddyy
xlim([datetime("2015-10-16 02:03:00") datetime("2016-02-09")])% ver:185:301"2015-10-15"
ylim([0 1600])
xtickangle(45)

ax3.YAxisLocation = 'right';
ax3.Box = 'off';
hold on
scatter(UTC_PO,SCD,80,"square",'MarkerEdgeColor',"#0072BD",...
              'MarkerFaceColor',"#D95319",...
              'LineWidth',1.5)

%%
