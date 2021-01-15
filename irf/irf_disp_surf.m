%IRF_DISP_SURF   Interactively plot cold plasma dispersion surfaces.
%
% This program needs the functions IRF_DISP_SURF_CALC and IRF_DISP_SURF_PL
%
% $Id$

% By Anders Tjulin. Last update 4/2-2003.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First we set some default values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Everything is normalized so that the electron gyro frequency is 1.

kc_z_max=0.5; % Max k parallel
kc_x_max=0.5; % Max k perpendicular

m_i=1836; % Ion mass in terms of electron mass
wp_e=0.32; % Electron plasma frequency
surfchoice=ones(1,5); % All 5 surfaces will be plotted by default
colorchoice=6; % The color is set by the group velocity
axisnorm = 1; % k and omega are normalized to particle species constants, 
% (1 is electrons, 2 is ions)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the first set of dispersion surfaces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[wfinal,extraparam]=irf_disp_surf_calc(kc_x_max,kc_z_max,m_i,wp_e);


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the figure window
%%%%%%%%%%%%%%%%%%%%%%%%%%

oldFigNumber=watchon;
figNumber=figure( ...
  'Visible','off', ...
  'NumberTitle','off', ...
  'Name','Dispersion surfaces');
axes( ...
  'Units','normalized', ...
  'Position',[0.07 0.07 0.60 0.86]);

h_TheFrame=uicontrol( ...
  'Style','frame', ...
  'Units','normalized', ...
  'Position',[0.73 0.03 0.24 0.94], ...
  'BackgroundColor',[0.70 0.70 0.70]);


%%%%%%%%%%%%%%%%%%
% Create the menus
%%%%%%%%%%%%%%%%%%

% Change ion mass, recalculate and plot

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.75 0.90 0.07 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','right', ...
  'String','m_i =');

h_mass = uicontrol( ...
  'Style','edit', ...
  'Units','normalized', ...
  'Position', [0.82 0.89 0.08 0.05], ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Callback','m_i=str2num(get(h_mass,''String''));[wfinal,extraparam]=irf_disp_surf_calc(kc_x_max,kc_z_max,m_i,wp_e);irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String',num2str(m_i));

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.91 0.9 0.055 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','left', ...
  'String','m_e');


% Change plasma frequency, recalculate, and plot

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.74 0.85 0.07 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','right', ...
  'String','w_pe =');

h_wp = uicontrol( ...
  'Style','edit', ...
  'Units','normalized', ...
  'Position', [0.82 0.84 0.08 0.05], ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Callback','wp_e=str2num(get(h_wp,''String''));[wfinal,extraparam]=irf_disp_surf_calc(kc_x_max,kc_z_max,m_i,wp_e);irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String',num2str(wp_e));

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.91 0.85 0.055 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','left', ...
  'String','w_ce');


% Choose surfaces to plot, and then plot them

h_s1 = uicontrol( ...
  'Style','checkbox', ...
  'Units','normalized', ...
  'Position', [0.75 0.74 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', surfchoice(1), ...
  'Callback','surfchoice(1)=get(h_s1,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','Surface 1');

h_s2 = uicontrol( ...
  'Style','checkbox', ...
  'Units','normalized', ...
  'Position', [0.75 0.69 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', surfchoice(2), ...
  'Callback','surfchoice(2)=get(h_s2,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','Surface 2');

h_s3 = uicontrol( ...
  'Style','checkbox', ...
  'Units','normalized', ...
  'Position', [0.75 0.64 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', surfchoice(3), ...
  'Callback','surfchoice(3)=get(h_s3,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','Surface 3');

h_s4 = uicontrol( ...
  'Style','checkbox', ...
  'Units','normalized', ...
  'Position', [0.75 0.59 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', surfchoice(4), ...
  'Callback','surfchoice(4)=get(h_s4,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','Surface 4');

h_s5 = uicontrol( ...
  'Style','checkbox', ...
  'Units','normalized', ...
  'Position', [0.75 0.54 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', surfchoice(5), ...
  'Callback','surfchoice(5)=get(h_s5,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','Surface 5');


% Choose the colors, and plot

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.75 0.44 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'String','Color');

h_colors = uicontrol( ...
  'Style','popupmenu', ...
  'Units','normalized', ...
  'Position', [0.75 0.41 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', colorchoice, ...
  'Callback','colorchoice=get(h_colors,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','dn/n|c B/E|Elong/E|Epar/E|Bpar/B|v_g|polarization E|log10(WE/WB)|log10(We/Wi)|log10(Ve/Vi)|log10(Wp/Wf)|polarization B|vp/vA|v_{e,par}/v_{e,perp}|v_{i,par}/v_{i,perp}|log10(We/Wf)|dn_e/dn_i|(dn_e/n)/(dB/B)|(dn_i/n)/(dB/B)|(dn_e/n)/(dBpar/B)|(dn_i/n)/(dBpar/B)|dn_e/(k E eps0/e)|S_{par}/S_{tot}');


% Choose the axis normailzations, and plot

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.75 0.34 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'String','Axis species');

h_axnorm = uicontrol( ...
  'Style','popupmenu', ...
  'Units','normalized', ...
  'Position', [0.75 0.31 0.2 0.05], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','center', ...
  'Value', 1, ...
  'Callback','axisnorm=get(h_axnorm,''Value'');irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String','electron|ion');


% Choose max k values, recalculate, and plot

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.75 0.25 0.15 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','left', ...
  'String','Max k_x c/w_ce:');

h_kx = uicontrol( ...
  'Style','edit', ...
  'Units','normalized', ...
  'Position', [0.90 0.24 0.05 0.05], ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Callback','kc_x_max=str2num(get(h_kx,''String''));[wfinal,extraparam]=irf_disp_surf_calc(kc_x_max,kc_z_max,m_i,wp_e);irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String',num2str(kc_x_max));

h_temp = uicontrol( ...
  'Style','text', ...
  'Units','normalized', ...
  'Position', [0.75 0.2 0.15 0.03], ...
  'BackgroundColor',[0.7 0.7 0.7], ...
  'HorizontalAlignment','left', ...
  'String','Max k_z c/w_ce:');

h_kz = uicontrol( ...
  'Style','edit', ...
  'Units','normalized', ...
  'Position', [0.90 0.19 0.05 0.05], ...
  'BackgroundColor',[1 1 1], ...
  'HorizontalAlignment','center', ...
  'Callback','kc_z_max=str2num(get(h_kz,''String''));[wfinal,extraparam]=irf_disp_surf_calc(kc_x_max,kc_z_max,m_i,wp_e);irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)', ...
  'String',num2str(kc_z_max));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the surfaces for the first time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

watchoff(oldFigNumber);
set(figNumber,'Visible','on')
irf_disp_surf_pl(kc_x_max,kc_z_max,wfinal,extraparam,surfchoice,colorchoice,axisnorm,wp_e,m_i)
view(-37.5,30)
