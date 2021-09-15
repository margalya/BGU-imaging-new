
function imaging(runVer)%, isFTP)
% change back:
% open two imaging (online and offline) 
% delete imaging pics
% remove loop condition (and at the end) - OK
% IDS_Main.dir in creaeConsts.m - OK
% in run change file path '/' to '\' (also in createconsts/idsReadFunction,
%  '/' to '\': analyzeAndPlot

if nargin == 0
    imaging('offline');
    imaging('online');%, 'noFTP');
    return
end
% if nargin == 1 
%     if (strcmp(runVer, 'FTP') || strcmp(runVer, 'FTP') )
%         imaging('offline', runVer);
%         imaging('online', runVer);
%     else
%         imaging(runVer, 'FTP');
%     end
%     return
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defining consts
%
appData.consts.vertion = '4.6.6';
appData.consts. saveVersion = '-v7';
appData.consts.runVer = runVer;

appData.consts.Mrb = 1.44e-25; 
appData.consts.Kb = 1.38e-23; 
% appData.consts.detun = 1e6;%          %  off resonance detuning
appData.consts.wavelength = 780.246e-9;                      %  [m]
appData.consts.linew = 6.065e6;%     %  [Hz]   
                                                    % line width of the Rb87 cooling transition: Lambda = 2*pi*linew
appData.consts.scatcross0 = 3*appData.consts.wavelength^2/2/pi;   % scattering cross section for Rb87 in m^2
appData.consts.Isat = 16.6933; %35.7713 [W/m^2] Saturation Intensity, for isotropic light field. For sigma+/- light is it 16.6933 [W/m^2]
% appData.consts.scatcross = appData.consts.scatcross0;      %  resonant imaging 
% appData.consts.defaultDetuning = 0;
% consts.scatcross = scatcross0 * 1/(1+(detun*2/linew)^2);   % off resonance scattering cross section


appData.consts.winName = 'Imaging Analysis: Picture ';% num2str(handles.data.num)];
appData.consts.screenWidth = 1280;
appData.consts.screenHeight = 780;
appData.consts.strHeight = 20;
appData.consts.maxplotSize = round(appData.consts.screenHeight*0.75);
appData.consts.xyPlotsHeight = round(appData.consts.screenHeight-(5+appData.consts.maxplotSize+appData.consts.strHeight*2.5));
appData.consts.fontSize = 9;
appData.consts.componentHeight = 22;
appData.consts.folderIcon = imread('folder28.bmp');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create consts
appData = createConsts(appData);

% if strcmp(isFTP, 'FTP')
%     appData.consts.LVFile = appData.consts.defaultLVFile;
% else
%     appData.consts.LVFile = 'tempLVData.txt';
% %     appData.data.LVData = LVData.readLabview('tempLVData.txt');
% end
appData.data.LVData = [];
appData.data.lastLVData = [];
% appData.data.isLastLVData = 0;
appData.data.firstLVData = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defining data
%

appData.data.isRun = 0;
% appData.data.scatcross = appData.consts.scatcross0 * 1/(1+(detun*2/linew)^2);   % off resonance scattering cross section

% appData.data.atoms = [];
% appData.data.back = [];
appData.data.dark = [];
% appData.data.absorption = [];
% appData.data.ROI = [];
% appData.data.pic = [];
% appData.data.atomsNo = 0;
appData.data.date = datestr(now);
appData.data.fitType = appData.consts.fitTypes.default;
appData.data.fits = appData.consts.fitTypes.fits;
appData.data.plotType = appData.consts.plotTypes.default;
appData.data.plots = appData.consts.plotTypes.plots;
% appData.data.picNo = -1;
% appData.data.saveParam = -1;
% appData.data.saveParamVal = -1;

appData.data.ROIUnits = appData.consts.ROIUnits.default;
appData.data.ROITypes = appData.consts.ROIUnits.ROITypes;
appData.data.ROISizeX = appData.consts.ROIUnits.defaultSizeX;
appData.data.ROISizeY = appData.consts.ROIUnits.defaultSizeY;
appData.data.ROICenterX = 0;
appData.data.ROICenterY = 0;
% appData.data.ROILeft = -1;
% appData.data.ROIRight = -1;
% appData.data.ROITop = -1;
% appData.data.ROIBottom = -1;

appData.data.xPosMaxBack = 0;
appData.data.yPosMaxBack = 0;
% appData.data.xPosMax = 0;
% appData.data.yPosMax = 0;
appData.analyze.LineSpec = 1;

% appData.data.cameraType = appData.consts.cameraTypes.default;
appData.data.camera = appData.consts.cameras{appData.consts.cameraTypes.default};%{appData.data.cameraType};
appData.data.plotWidth = round(appData.consts.maxplotSize*(appData.data.camera.width / appData.data.camera.height));
appData.data.plotHeight = appData.consts.maxplotSize;
if ( appData.data.plotWidth > appData.consts.maxplotSize )
    appData.data.plotWidth = appData.consts.maxplotSize;
    appData.data.plotHeight = round(appData.consts.maxplotSize*( appData.data.camera.height / appData.data.camera.width));
end

appData.options.calcAtomsNo = appData.consts.calcAtomsNo.default;
appData.options.calcs = appData.consts.calcAtomsNo.calcs;
appData.options.plotSetting = appData.consts.plotSetting.default;
appData.options.cameraType = appData.consts.cameraTypes.default;
appData.options.avgWidth = appData.consts.defaultAvgWidth;
appData.options.detuning = appData.consts.defaultDetuning;
appData.options.doPlot = appData.consts.defaultDoPlot;


% appData.save.defaultDir = ['F:\My Documents\Experimental\' datestr(now,29)];%'C:\Documents and Settings\broot\Desktop\shimi';
% mkdir(appData.save.defaultDir); %#ok<NASGU>
appData.save.saveDir=appData.save.defaultDir;
appData.save.saveParam = appData.consts.saveParams.default;
appData.save.saveParamVal = appData.consts.saveParamValDefault;
appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
appData.save.commentStr = appData.consts.commentStr;
appData.save.isSave = 0;
appData.save.picNo = 1;

appData.loop.isLoop = 0;
appData.loop.measurementsList = {};
appData.loop.measurements = [];
% appData.loop.loopStart = 0;
% appData.loop.loopJump = 0;
% appData.loop.noJumps = 0;
% appData.loop.noIterations = 0;
% appData.loop.curVal = 0;
% appData.loop.curJump = 0;
% appData.loop.curIteration = 0;

% appData.monitoring.currentMonitoring = [];
% appData.monitoring.onlySavedPics = 1;
% appData.monitoring.isMonitoring = 0;
% appData.monitoring.monitoringData = cell(1, 3);
% appData.monitoring.figs = [];

appData.analyze.currentAnalyzing = [];
% appData.analyze.analyzePicNums = [1 : 5];
appData.analyze.showPicNo = 1;
appData.analyze.isReadPic = 0;
appData.analyze.readDir = appData.save.defaultDir;
appData.analyze.totAppData = 0;

% appData.fitData = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% defining components
%

appData.ui.win = figure('Visible', 'off', ...
    'Name', appData.consts.winName, ...
    'Units', 'Pixels', ...
    'Position', [appData.consts.winXPos appData.consts.winYPos appData.consts.screenWidth appData.consts.screenHeight], ...
    'Resize', 'off', ...
    'MenuBar', 'None', ...
    'Toolbar', 'Figure', ...
    'NumberTitle', 'off' , ...
    'HandleVisibility', 'callback');%, ...
%      'DeleteFcn', {@closewin_Callback},...
%     'ResizeFcn', @win_resize);

% creating axes
%%%%%%%%
appData.ui.plot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5 5 appData.data.plotWidth appData.data.plotHeight], ...
    'HandleVisibility', 'callback', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
appData.ui.xPlot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5 5+appData.data.plotHeight+appData.consts.strHeight appData.data.plotWidth appData.consts.xyPlotsHeight], ...
    'HandleVisibility', 'callback', ...
    'XTickLabel', '', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
xlabel(appData.ui.xPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
ylabel(appData.ui.xPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);
appData.ui.yPlot = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [5+appData.data.plotWidth+appData.consts.strHeight 5 appData.consts.xyPlotsHeight appData.data.plotHeight], ...
    'HandleVisibility', 'callback', ...
    'YTickLabel', '', ...
    'XAxisLocation', 'top', ...
    'YAxisLocation', 'right');
ylabel(appData.ui.yPlot, 'Distance [mm]', 'FontSize', appData.consts.fontSize);
xlabel(appData.ui.yPlot, 'Optical Density', 'FontSize', appData.consts.fontSize);

% creating panel - Plotting and Fitting
%%%%%%%%%%%%%%%%%%%%

appData.ui.pPlotFit = uipanel('Parent', appData.ui.win, ...
    'Title', 'Plotting and Fitting', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [640 630 225 150], ... 
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st11 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'ROI Size:', ...
    'Units', 'pixels', ...
    'Position', [5 5 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etROISizeX = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROISizeX), ...
    'Units', 'pixels', ...
    'Position', [80 5 30 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROISizeX_Callback}); 
appData.ui.etROISizeY = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROISizeY), ...
    'Units', 'pixels', ...
    'Position', [110 5 30 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROISizeY_Callback}); 
appData.ui.etROICenterX = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROICenterX), ...
    'Units', 'pixels', ...
    'Position', [140 5 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROICenterX_Callback}); 
appData.ui.etROICenterY = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'edit', ...
    'String', num2str(appData.data.ROICenterY), ...
    'Units', 'pixels', ...
    'Position', [180 5 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etROICenterY_Callback}); 

appData.ui.st12 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'ROI Units:', ...
    'Units', 'pixels', ...
    'Position', [5 40 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmROIUnits = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.ROIUnits.str, ...
    'Value', appData.data.ROIUnits, ...
    'Units', 'pixels', ...
    'Position', [80 45  140 20], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmROIUnits_Callback}); 

appData.ui.st13 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'Plot Type:', ...
    'Units', 'pixels', ...
    'Position', [5 70 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmPlotType = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.plotTypes.str, ...
    'Value', appData.data.plotType, ...
    'Units', 'pixels', ...
    'Position', [80 75  140 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmPlotType_Callback}); 

appData.ui.st14 = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'text', ...
    'String', 'Fit Type:', ...
    'Units', 'pixels', ...
    'Position', [5 100 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmFitType = uicontrol(appData.ui.pPlotFit, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.fitTypes.str, ...
    'Value', appData.data.fitType, ...
    'Units', 'pixels', ...
    'Position', [80 105  140 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmFitType_Callback}); 

    

% creating panel - Options
%%%%%%%%%%%%%%%%%%%%

appData.ui.pOption = uipanel('Parent', appData.ui.win, ...
    'Title', 'Options', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 5 485 90], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);


appData.ui.pmCalcAtomsNo = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.calcAtomsNo.str, ...
    'Value', appData.options.calcAtomsNo, ...
    'Units', 'pixels', ...
    'Position', [5 10 100 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmCalcAtomsNo_Callback}); 
appData.ui.tbReanalyze = uicontrol(appData.ui.pOption, ...
    'Style', 'togglebutton', ...
    'String', 'Re-Analyze', ...
    'Units', 'pixels', ...
    'Position', [110 5 100 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@tbReanalyze_Callback}); 
appData.ui.pmPlotSetting = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.plotSetting.str, ...
    'Value', appData.options.plotSetting, ...
    'Units', 'pixels', ...
    'Position', [215 10 115 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmPlotSetting_Callback}); 
appData.ui.pmCameraType = uicontrol(appData.ui.pOption, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.cameraTypes.str, ...
    'Value', appData.options.cameraType, ...
    'Units', 'pixels', ...
    'Position', [335 10 145 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmCameraType_Callback}); 


appData.ui.st21 = uicontrol(appData.ui.pOption, ...
    'Style', 'text', ...
    'String', 'Detuning (MHz):', ...
    'Units', 'pixels', ...
    'Position', [5 40 110 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etDetuning = uicontrol(appData.ui.pOption, ...
    'Style', 'edit', ...
    'String', num2str(appData.options.detuning), ...
    'Units', 'pixels', ...
    'Position', [110 40 35 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etDetuning_Callback}); 
appData.ui.st22 = uicontrol(appData.ui.pOption, ...
    'Style', 'text', ...
    'String', 'Avg. Width (half):', ...
    'Units', 'pixels', ...
    'Position', [150 40 130 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etAvgWidth = uicontrol(appData.ui.pOption, ...
    'Style', 'edit', ...
    'String', num2str(appData.options.avgWidth), ...
    'Units', 'pixels', ...
    'Position', [260 40 35 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etAvgWidth_Callback}); 
 appData.ui.pbCompareFiles = uicontrol(appData.ui.pOption, ...
    'Style', 'pushbutton', ...
    'String', 'Compare', ...
    'Units', 'pixels', ...
    'Position', [405 40 75 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbCompareFiles_Callback}); 



% creating panel - Loop Options
%%%%%%%%%%%%%%%%%%%%%

appData.ui.pLoop = uipanel('Parent', appData.ui.win, ...
    'Title', 'Loop', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 95 485 85], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

% appData.ui.st31 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'No. Jumps:', ...
%     'Units', 'pixels', ...
%     'Position', [5 5 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etNoLoops = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.noJumps), ...
%     'Units', 'pixels', ...
%     'Position', [100 5 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etNoJumps_Callback}); 
% appData.ui.sNoLoops = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [150 5 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sNoJumps_Callback}); 
% appData.ui.st32 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'No. Iterations:', ...
%     'Units', 'pixels', ...
%     'Position', [175 5 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etNoIterations = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.noIterations), ...
%     'Units', 'pixels', ...
%     'Position', [270 5 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etNoIterations_Callback}); 
% appData.ui.sNoIterations = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [320 5 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sNoIterations_Callback}); 
% 
% appData.ui.st33 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'Loop Start:', ...
%     'Units', 'pixels', ...
%     'Position', [5 35 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etLoopStart = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.loopStart), ...
%     'Units', 'pixels', ...
%     'Position', [100 40 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etLoopStart_Callback}); 
% appData.ui.sLoopStart = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [150 40 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sLoopStart_Callback}); 
% appData.ui.st34 = uicontrol(appData.ui.pLoop, ...
%     'Style', 'text', ...
%     'String', 'Loop Jump:', ...
%     'Units', 'pixels', ...
%     'Position', [175 35 90 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize); 
% appData.ui.etLoopJump = uicontrol(appData.ui.pLoop, ...
%     'Style', 'edit', ...
%     'String', num2str(appData.loop.loopJump), ...
%     'Units', 'pixels', ...
%     'Position', [270 40 50 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etLoopJump_Callback}); 
% appData.ui.sLoopJump = uicontrol(appData.ui.pLoop, ...
%     'Style', 'slider', ...
%     'Max', 2, ...
%     'Min', 0, ...
%     'SliderStep', [0.5 0.5], ...
%     'Value', 1, ...
%     'Units', 'pixels', ...
%     'Position', [320 40 20 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'Callback', {@sLoopJump_Callback}); 


% appData.ui.pbEditLoop = uicontrol(appData.ui.pLoop, ...
%     'Style', 'pushbutton', ...
%     'String', 'Edit', ...
%     'Units', 'pixels', ...
%     'Position', [70 5 60 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'center', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@pbEditLoop_Callback});  
% appData.ui.pbRemoveLoop = uicontrol(appData.ui.pLoop, ...
%     'Style', 'pushbutton', ...
%     'String', 'Remove', ...
%     'Units', 'pixels', ...
%     'Position', [135 5 70 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'center', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@pbRemoveLoop_Callback}); 

appData.ui.pmAvailableLoops = uicontrol(appData.ui.pLoop, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.availableLoops.str, ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [5 13 130 20], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmAvailableLoops_Callback}); 

appData.ui.pbAddMeasurement = uicontrol(appData.ui.pLoop, ...
    'Style', 'pushbutton', ...
    'String', 'Add', ...
    'Units', 'pixels', ...
    'Position', [140 5 60 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pbAddMeasurement_Callback});  

appData.ui.lbMeasurementsList = uicontrol(appData.ui.pLoop, ...
    'Style', 'listbox', ...
    'String', '', ...
    'Min', 0, ...
    'Max', 1, ...
    'Units', 'pixels', ...
    'Position', [205 5 135 60], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'KeyPressFcn', {@lbMeasurementsList_KeyPressFcn});

appData.ui.tbLoop = uicontrol(appData.ui.pLoop, ...
    'Style', 'togglebutton', ...
    'String', 'Loop On/Off', ...
    'Value', appData.loop.isLoop, ...
    'Units', 'pixels', ...
    'Position', [350 10 125 50], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbLoop_Callback}); 


% creating panel - Save Options
%%%%%%%%%%%%%%%%%%%%%

appData.ui.pSave = uipanel('Parent', appData.ui.win, ...
    'Title', 'Save', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [790 180 485 145], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st41 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Save Param:', ...
    'Units', 'pixels', ...
    'Position', [5 5 90 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmSaveParam = uicontrol(appData.ui.pSave, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.saveParams.str, ...
    'Value', appData.save.saveParam, ...
    'Units', 'pixels', ...
    'Position', [105 10 90 appData.consts.componentHeight], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmSaveParam_Callback}); 
appData.ui.st42 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Param Val:', ...
    'Units', 'pixels', ...
    'Position', [200 5 90 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etParamVal = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', num2str(appData.save.saveParamVal), ...
    'Units', 'pixels', ...
    'Position', [275 5 65 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etParamVal_Callback}); 
% appData.ui.etSaveOtherParam = uicontrol(appData.ui.pSave, ...
%     'Style', 'edit', ...
%     'String', appData.consts.saveOtherParamStr, ...
%     'Units', 'pixels', ...
%     'Position', [215 5 125 appData.consts.componentHeight+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@etSaveOtherParam_Callback}); 

appData.ui.st43 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'File Comment:', ...
    'Units', 'pixels', ...
    'Position', [5 35 100 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etComment = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', appData.consts.commentStr, ...
    'Units', 'pixels', ...
    'Position', [105 35 235 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etComment_Callback}); 

appData.ui.pbOpenSaveDir = uicontrol(appData.ui.pSave, ...
    'Style', 'pushbutton', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [5 65 30 30], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'CData', appData.consts.folderIcon, ...
    'Callback', {@pbOpenSaveDir_Callback}); 
appData.ui.st44 = uicontrol(appData.ui.pSave, ...
    'Style', 'text', ...
    'String', 'Pic. No.:', ...
    'Units', 'pixels', ...
    'Position', [40 65 60 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etPicNo = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', num2str(appData.save.picNo), ...
    'Units', 'pixels', ...
    'Position', [105 65 50 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etPicNo_Callback}); 
appData.ui.sPicNo = uicontrol(appData.ui.pSave, ...
    'Style', 'slider', ...
    'Max', 2, ...
    'Min', 0, ...
    'SliderStep', [0.5 0.5], ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [155 65 20 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Callback', {@sPicNo_Callback}); 
appData.ui.pbSaveCurrent = uicontrol(appData.ui.pSave, ...
    'Style', 'pushbutton', ...
    'String', 'Save Current Pic.', ...
    'Units', 'pixels', ...
    'Position', [180 65 160 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'center', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pbSaveCurrent_Callback});  

appData.ui.tbSave = uicontrol(appData.ui.pSave, ...
    'Style', 'togglebutton', ...
    'String', 'Save All', ...
    'Value', appData.save.isSave, ...
    'Units', 'pixels', ...
    'Position', [350 10 125 75], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbSave_Callback}); 

appData.ui.etSaveDir = uicontrol(appData.ui.pSave, ...
    'Style', 'edit', ...
    'String', appData.save.saveDir, ...
    'Units', 'pixels', ...
    'Position', [5 97 485-10 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etSaveDir_Callback}); 


% creating panel - Fit Results
%%%%%%%%%%%%%%%%%%%%

% appData.ui.pFitResults = uipanel('Parent', appData.ui.win, ...
%     'Title', 'Fit Results', ...
%     'TitlePosition', 'lefttop', ...
%     'Units', 'pixels', ...
%     'Position', [790 325 485 220], ...% [790 325 485 305], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize);
appData.ui.tmp = axes('Parent', appData.ui.win, ...
    'Units', 'pixels', ...
    'Position', [790 325 1 1], ...
    'HandleVisibility', 'off');

% Run Button
%%%%%%%%%%%%%%%%%%%%
            
appData.ui.tbRun = uicontrol(appData.ui.win, ...
    'Style', 'togglebutton', ...
    'String', 'Run', ...
    'Value', appData.data.isRun, ...
    'Units', 'pixels', ...
    'Position', [790 550 125 75], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbRun_Callback});


% creating panel - Monitoring
%%%%%%%%%%%%%%%%%%%%

% appData.ui.pMonitoring = uipanel('Parent', appData.ui.win, ...
%     'Title', 'Monitoring', ...
%     'TitlePosition', 'lefttop', ...
%     'Units', 'pixels', ...
%     'Position', [790+140 550 345 75], ...% [790 325 485 305], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize);
% 
% st71 = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'text', ...
%     'String', {'Available' 'Monitoring:'}, ...
%     'Units', 'pixels', ...
%     'Position', [5 5 70 appData.consts.componentHeight*2], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize);
% appData.ui.lbAvailableMonitoring = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'listbox', ...
%     'String', appData.consts.availableMonitoring.str, ...
%     'Max', length(appData.consts.availableMonitoring.str), ...
%     'Value', appData.monitoring.currentMonitoring, ...
%     'Units', 'pixels', ...
%     'Position', [80 5 125 appData.consts.componentHeight*2+5], ...
%     'BackgroundColor', 'white', ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%     'Callback', {@lbAvailableMonitoring_Callback}); 
% appData.ui.tbMonitoringOnOff = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'togglebutton', ...
%     'String', 'On/Off', ...
%     'Value', appData.monitoring.isMonitoring, ...
%     'Units', 'pixels', ...
%     'Position', [210 5 65 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize, ...    
%     'Callback', {@tbMonitoringOnOff_Callback}); 
% appData.ui.pbMonitoringSave = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'pushbutton', ...
%     'String', 'Save', ...
%     'Units', 'pixels', ...
%     'Position', [280 5 55 appData.consts.componentHeight+5], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'FontSize', appData.consts.fontSize, ...    
%     'Callback', {@pbMonitoringSave_Callback}); 
% cbOnlySavedPics = uicontrol(appData.ui.pMonitoring, ...
%     'Style', 'checkbox', ...
%     'String', 'Only Saved Pics', ...
%     'Max', 1, ...
%     'Min', 0, ...
%     'Value', appData.monitoring.onlySavedPics, ...
%     'Units', 'pixels', ...
%     'Position', [210 35 130 appData.consts.componentHeight], ...
%     'BackgroundColor', [0.8 0.8 0.8], ...
%     'HorizontalAlignment', 'left', ...
%     'FontSize', appData.consts.fontSize, ...
%      'Callback', {@cbOnlySavedPics_Callback});


% creating panel - Analyze Options
%%%%%%%%%%%%%%%%%%%%

appData.ui.pAnylize = uipanel('Parent', appData.ui.win, ...
    'Title', 'Analyze Options', ...
    'TitlePosition', 'lefttop', ...
    'Units', 'pixels', ...
    'Position', [870 580 405 200], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize);

appData.ui.st81 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', {'Analyze' 'Data:'}, ...
    'Units', 'pixels', ...
    'Position', [5 55 55 appData.consts.componentHeight*2+15], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.lbAvailableAnalyzing = uicontrol(appData.ui.pAnylize, ...
    'Style', 'listbox', ...
    'String', appData.consts.availableAnalyzing.str, ...
    'Max', length(appData.consts.availableAnalyzing.str), ...
    'Value', appData.analyze.currentAnalyzing, ...
    'Units', 'pixels', ...
    'Position', [60 34 135 appData.consts.componentHeight*2+33], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@lbAvailableAnalyzing_Callback}); 
appData.ui.pbSaveToWorkspace = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Save to WS', ...
    'Units', 'pixels', ...
    'Position', [200 5 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbSaveToWorkspace_Callback}); 
appData.ui.pbClearTotappData = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Pic to WS', ...
    'Units', 'pixels', ...
    'Position', [310 5 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbPicToWorkspace_Callback}); 
appData.ui.pbAnalyze = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', 'Analyze', ...
    'Units', 'pixels', ...
    'Position', [200 35 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@pbAnalyze_Callback}); 
appData.ui.tbReadPics = uicontrol(appData.ui.pAnylize, ...
    'Style', 'togglebutton', ...
    'String', 'Read Pics', ...
    'Units', 'pixels', ...
    'Position', [310 35 90 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbReadPics_Callback}); 

appData.ui.st82 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', 'Pic No:', ...
    'Units', 'pixels', ...
    'Position', [5 115 50 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etShowPicNo = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', num2str(appData.analyze.showPicNo), ...
    'Units', 'pixels', ...
    'Position', [55 115 40 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etShowPicNo_Callback}); 
appData.ui.sShowPicNo = uicontrol(appData.ui.pAnylize, ...
    'Style', 'slider', ...
    'Max', 2, ...
    'Min', 0, ...
    'SliderStep', [0.5 0.5], ...
    'Value', 1, ...
    'Units', 'pixels', ...
    'Position', [90 115 20 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'Callback', {@sShowPicNo_Callback}); 
appData.ui.tbReadPic = uicontrol(appData.ui.pAnylize, ...
    'Style', 'togglebutton', ...
    'String', 'Read Pic', ...
    'Value', appData.analyze.isReadPic, ...
    'Units', 'pixels', ...
    'Position', [115 115 75 appData.consts.componentHeight+5], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'FontSize', appData.consts.fontSize, ...    
    'Callback', {@tbReadPic_Callback}); 
appData.ui.st83 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', 'Pics Nums:', ...
    'Units', 'pixels', ...
    'Position', [200 115 85 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.etAnalyzePicNums = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [280 115 120 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etAnalyzePicNums_Callback}); 

appData.ui.pbOpenReadDir = uicontrol(appData.ui.pAnylize, ...
    'Style', 'pushbutton', ...
    'String', '', ...
    'Units', 'pixels', ...
    'Position', [5 145 30 30], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'CData', appData.consts.folderIcon, ...
    'Callback', {@pbOpenReadDir_Callback}); 
appData.ui.etReadDir = uicontrol(appData.ui.pAnylize, ...
    'Style', 'edit', ...
    'String', appData.analyze.readDir, ...
    'Units', 'pixels', ...
    'Position', [40 147 360 appData.consts.componentHeight+5], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@etReadDir_Callback}); 
appData.ui.st84 = uicontrol(appData.ui.pAnylize, ...
    'Style', 'text', ...
    'String', 'LineSpec:', ...
    'Units', 'pixels', ...
    'Position', [40 7 80 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize); 
appData.ui.pmLineSpec = uicontrol(appData.ui.pAnylize, ...
    'Style', 'popupmenu', ...
    'String', appData.consts.pmLineSpec.str, ...
    'Value', appData.analyze.LineSpec, ...
    'Units', 'pixels', ...
    'Position', [115 10 80 22], ...
    'BackgroundColor', 'white', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@pmLineSpec_Callback});
appData.ui.cbDoPlot = uicontrol(appData.ui.pAnylize, ...
    'Style', 'checkbox', ...
    'String', 'Update plots', ...
    'Max', 1, ...
    'Min', 0, ...
    'Value', appData.options.doPlot, ...
    'Units', 'pixels', ...
    'Position', [300 69 150 appData.consts.componentHeight], ...
    'BackgroundColor', [0.8 0.8 0.8], ...
    'HorizontalAlignment', 'right', ...
    'FontSize', appData.consts.fontSize, ...
    'Callback', {@cbDoPlot_Callback});

% last commands
if strcmp(runVer, 'online')
    set(appData.ui.pAnylize, 'Visible', 'off');
    appData.consts.winName = 'Imaging Analysis (Online): Picture ';
%     if strcmp(isFTP, 'FTP')
%         ftpname=ftp(appData.consts.ftpAddress);
%         cd(ftpname, appData.consts.ftpDir);
%     end
elseif strcmp(runVer, 'offline')
    set(appData.ui.tbRun, 'Visible', 'off');
    set(appData.ui.pLoop, 'Visible', 'off');
    appData.consts.winName = 'Imaging Analysis (Offline): Picture ';
else
    errordlg('Function input incorrect', 'Error', 'modal');
    return
end
set(appData.ui.win, 'Name', appData.consts.winName);
set(appData.ui.win, 'Visible', 'on');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function closewin_Callback(object, eventdata) %#ok<INUSD>
%     if strcmp(isFTP, 'FTP')
%         close(ftpname);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROISizeX_Callback(object, eventdata) %#ok<*DEFNU,INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz<= 0
        set(object, 'String', num2str(appData.data.ROISizeX));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROISizeX = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROISizeY_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz<= 0
        set(object, 'String', num2str(appData.data.ROISizeY));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROISizeY = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROICenterX_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz< 0
        set(object, 'String', num2str(appData.data.ROICenterX));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROICenterX = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etROICenterY_Callback(object, eventdata) %#ok<INUSD>
    sz = str2double(get(object, 'String'));
    if isnan(sz) || sz< 0
        set(object, 'String', num2str(appData.data.ROICenterY));
        errordlg('Input must be a positive number','Error', 'modal');
    else
        appData.data.ROICenterY = sz;
        appData = updateROI(appData);
        onlyPlot(appData);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmROIUnits_Callback(object, eventdata) %#ok<INUSD
    appData.data.ROIUnits = get(object, 'Value');
    appData = updateROI(appData);
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmFitType_Callback(object, eventdata) %#ok<INUSD>    
    appData.data.fitType = get(object, 'Value');
    if ( appData.save.isSave == 1 )
        appData.save.picNo = appData.save.picNo - 1;
    end
    appData = analyzeAndPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmPlotType_Callback(object, eventdata) %#ok<INUSD>
    appData.data.plotType = get(object, 'Value');
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmCalcAtomsNo_Callback(object, eventdata) %#ok<INUSD>
    appData.options.calcAtomsNo = get(object, 'Value');
    appData = updateROI(appData);
    onlyPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReanalyze_Callback(object, eventdata) %#ok<INUSD>    
    if (get(object, 'Value') == 0)
        return
    end
    appData.data.fits = appData.consts.fitTypes.fits;
%     appData.data.plots = appData.consts.plotTypes.plots;
    if ( appData.save.isSave == 1 )
        appData.save.picNo = appData.save.picNo - 1;
    end
    appData = analyzeAndPlot(appData);
    set(object, 'Value', 0);
end

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmPlotSetting_Callback(object, eventdata) %#ok<INUSD>
    appData.options.plotSetting = get(object, 'Value');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmCameraType_Callback(object, eventdata) %#ok<INUSD>
    appData.options.cameraType = get(object, 'Value');
    appData.data.camera = appData.consts.cameras{appData.options.cameraType};
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etDetuning_Callback(object, eventdata) %#ok<INUSD>
    det = str2double(get(object, 'String'));
    if isnan(det)
        set(object, 'St`ring', num2str(appData.options.detuning));
        errordlg('Input must be a  number','Error', 'modal');
    else
        appData.options.detuning = det;
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etAvgWidth_Callback(object, eventdata) %#ok<INUSD>
    avg = str2double(get(object, 'String'));
    if isnan(avg) || avg < 0 || floor(avg) ~= avg  
        set(object, 'String', num2str(appData.options.avgWidth));
        errordlg('Input must be a positive integer','Error', 'modal');
    else
        appData.options.avgWidth = avg;
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cbDoPlot_Callback(object, eventdata) %#ok<INUSD>
    appData.options.doPlot = get(object, 'Value');
    if appData.options.doPlot == 1
        % Plot image and results
        tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbCompareFiles_Callback(object, eventdata) %#ok<INUSD>
    answer = measDlg({'First File' 'Second File'}, 'Compare Two Files', [1 1]',  {'first file' 'second file'}, ...
        struct('Interpreter', 'tex', 'WindowStyle', 'normal', 'Resize', 'off'),  {'file' 'file' }, {[appData.save.saveDir '\*.txt'] [appData.save.saveDir '\*.txt'] });
    if ~isempty(answer)
        ret = compareLabview( LVData.readLabview(answer{1}), LVData.readLabview(answer{2})); %#ok<NASGU>
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etNoJumps_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) || val <= 0 || floor(val) ~= val )
%         set(object, 'String', num2str(appData.loop.noJumps));
%         errordlg('Input must be positive integer','Error', 'modal');
%     else
%         appData.loop.noJumps = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etNoIterations_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) || val <= 0 || floor(val) ~= val )
%         set(object, 'String', num2str(appData.loop.noIterations));
%         errordlg('Input must be positive integer','Error', 'modal');
%     else
%         appData.loop.noIterations = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etLoopStart_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) )
%         set(object, 'String', num2str(appData.loop.loopStart));
%         errordlg('Input must be a number','Error', 'modal');
%     else
%         appData.loop.loopStart = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function etLoopJump_Callback(object, eventdata) %#ok<INUSD>
%     val = str2double(get(object, 'String'));
%     if ( isnan(val) )
%         set(object, 'String', num2str(appData.loop.loopJump));
%         errordlg('Input must be a number','Error', 'modal');
%     else
%         appData.loop.loopJump = val;
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sNoJumps_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         if ( appData.loop.noJumps > 1 )
%             appData.loop.noJumps = appData.loop.noJumps - 1;
%         end
%     elseif ( val == 2 )
%         appData.loop.noJumps = appData.loop.noJumps + 1;
%     end
%     set(appData.ui.etNoLoops, 'String', num2str(appData.loop.noJumps));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sNoIterations_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         if ( appData.loop.noIterations > 1 )
%             appData.loop.noIterations = appData.loop.noIterations - 1;
%         end
%     elseif ( val == 2 )
%         appData.loop.noIterations = appData.loop.noIterations + 1;
%     end
%     set(appData.ui.etNoIterations, 'String', num2str(appData.loop.noIterations));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sLoopStart_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         appData.loop.loopStart = appData.loop.loopStart - 1;
%     elseif ( val == 2 )
%         appData.loop.loopStart = appData.loop.loopStart + 1;
%     end
%     set(appData.ui.etLoopStart, 'String', num2str(appData.loop.loopStart));
%     set(object, 'Value', 1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function sLoopJump_Callback(object, eventdata) %#ok<INUSD>
%     val = get(object, 'Value');
%     if ( val == 0 )
%         appData.loop.loopJump = appData.loop.loopJump - 1;
%     elseif ( val == 2 )
%         appData.loop.loopJump = appData.loop.loopJump + 1;
%     end
%     set(appData.ui.etLoopJump, 'String', num2str(appData.loop.loopJump));
%     set(object, 'Value', 1);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmAvailableLoops_Callback(object, eventdata)  %#ok<INUSD>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lbMeasurementsList_KeyPressFcn (object, eventdata)  %#ok<INUSL>
    val = get(appData.ui.lbMeasurementsList, 'Value');
    if isempty(val)
        return
    end
    switch(eventdata.Key)
        case 'return'
%              fieldNames = fieldnames(appData.loop.measurements{val});
%             for i = 1 : length(fieldNames);
%                 if strcmp(fieldNames(i), 'GUI')
%                     appData.loop.measurements{val} = appData.loop.measurements{val}.createLoadObj();
%                     break
%                 end
%             end
            meas = appData.loop.measurements{val}.edit(appData);
%             meas = appData.loop.measurements{val}.initialize(appData);
            
%             fieldNames = fieldnames(appData.loop.measurements{val});
% %             for i = 1 : length(fieldNames);
%                 if strcmp(fieldNames(1), 'GUI')
%                     meas = appData.loop.measurements{val}.createLoadObj();
% %                     meas.updateGUI();
% %                     break
%                 end
% %             end
% %             appData.loop.measurements{val} = appData.loop.measurements{val}.load();
%             if isempty(meas) || meas.noIterations == -1
%                 return;
%             end
            appData.loop.measurements{val} = meas;  
        case 'removeFirst'
            set(appData.ui.lbMeasurementsList, 'Value', 1);
            appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
            appData.loop.measurementsList =  {appData.loop.measurementsList{2:end}}; %#ok<CCAT1>
            appData.loop.measurements = {appData.loop.measurements{2:end}}; %#ok<CCAT1>
            if val > length(appData.loop.measurementsList) && val > 1
                val = val-1;
            elseif isempty(appData.loop.measurementsList)
                val = [];
%                 set(appData.ui.tbLoop, 'Value', 0)
%                 tbLoop_Callback(appData.ui.tbLoop, []) ;
            end
            set(appData.ui.lbMeasurementsList, 'Value', val);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
        case 'delete'
            appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
            appData.loop.measurementsList = {appData.loop.measurementsList{1:val-1} appData.loop.measurementsList{val+1:end}};
            appData.loop.measurements =  {appData.loop.measurements{1:val-1} appData.loop.measurements{val+1:end}};
            if val > length(appData.loop.measurementsList) && val > 1
                val = val-1;
            elseif isempty(appData.loop.measurementsList)
                val = [];
                set(appData.ui.tbLoop, 'Value', 0)
                tbLoop_Callback(appData.ui.tbLoop, []) ;
            end
            set(appData.ui.lbMeasurementsList, 'Value', val);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbAddMeasurement_Callback(object, eventdata) %#ok<INUSD>
    
    appData.data.LVData = LVData.readLabview(appData.consts.defaultStrLVFile_Save);
    if isempty(appData.data.LVData)
        errordlg({'Cannot read file!!',  ['Maybe file does not exist: ' appData.consts.defaultStrLVFile_Save]},'Error', 'modal');
        return
    end
    appData.data.firstLVData = appData.data.LVData;

    val = get(appData.ui.pmAvailableLoops, 'Value');  
    h = appData.consts.availableLoops.createFncs{val};
    meas = h(appData);
    
%     fieldNames = fieldnames(meas);
% %     for i = 1 : length(fieldNames);
%         if strcmp(fieldNames(1), 'GUI')
%             meas = meas.createLoadObj();
% %             break
%         end
% %     end
    
    if isempty(meas) || meas.noIterations == -1
        return
    end
    appData.loop.measurements{length(appData.loop.measurements)+1} = meas;  
    
    appData.loop.measurementsList = get(appData.ui.lbMeasurementsList, 'String');
    appData.loop.measurementsList{length(appData.loop.measurementsList)+1} = meas.getMeasStr(appData);

    set(appData.ui.lbMeasurementsList, 'Value', 1);    
    set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbLoop_Callback(object, eventdata) 
    appData.loop.isLoop = get(object, 'Value');
    if ( appData.loop.isLoop == 0 )
        set(appData.ui.tbSave, 'Value', 0);
        tbSave_Callback(appData.ui.tbSave, eventdata)
        return
    end    
    if isempty(get(appData.ui.lbMeasurementsList, 'String'))
        warndlg('Measurements list is empty.', 'Warning', 'modal');
        set(appData.ui.tbLoop, 'Value', 0)
        tbLoop_Callback(object, eventdata);
        return
    end
    set(appData.ui.tbSave, 'Value', 1);
    tbSave_Callback(appData.ui.tbSave, eventdata);
%     set(appData.ui.etParamVal, 'String', 'wait...');
    if appData.loop.measurements{1}.position == 0
        [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
%         etSaveDir_Callback(appData.ui.etSaveDir, []);
    end
    
    set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
    etSaveDir_Callback(appData.ui.etSaveDir, []);
    appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
    appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
    set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
        
%     appData.loop.curVal = appData.loop.loopStart;
%     appData.save.saveParamVal = appData.loop.curVal;
%     set(appData.ui.etParamVal, 'String', num2str(appData.save.saveParamVal));
%     appData.loop.curJump = 1;
%     appData.loop.curIteration = 1;
end

% function tbSave_Callback(object, eventdata) %#ok<INUSD>
%     appData.save.isSave  = get(object, 'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmSaveParam_Callback(object, eventdata) %#ok<INUSD>
    appData.save.saveParam = get(object, 'Value');
%     str = get(object, 'String');
    otherParam = appData.consts.saveParams.otherParam;
    if ( appData.save.saveParam == otherParam )%&& ...
%             strcmp(str{otherParam}, appData.consts.saveParams.str{otherParam}))
        param = inputdlg('Enter param name:', 'Other param input');
        set(appData.ui.pmSaveParam, 'String', {appData.consts.saveParams.str{1:end-1} ['O.P. - ' param{1}]});
        appData.save.saveOtherParamStr = param;
%     elseif ( appData.save.saveParam == otherParam && ...
%             ~strcmp(str{otherParam}, appData.consts.saveParams.str{otherParam}))
        
    else    
        set(appData.ui.pmSaveParam, 'String', appData.consts.saveParams.str);
        appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etParamVal_Callback(object, eventdata) %#ok<INUSD>
    val = str2double(get(object, 'String'));
    if isnan(val)
        set(object, 'String', num2str(appData.save.saveParamVal));
        errordlg('Input must be a number','Error', 'modal');
    else
        appData.save.saveParamVal = val;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etComment_Callback(object, eventdata) %#ok<INUSD>
    appData.save.commentStr = get(object, 'String');
    if ( ~isempty(appData.save.commentStr) )
        appData.save.commentStr = ['-' appData.save.commentStr];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbOpenSaveDir_Callback(object, eventdata)   %#ok<INUSL>
    dirName = uigetdir(get(appData.ui.etSaveDir, 'String'));
    if ( dirName ~= 0 )
        set(appData.ui.etSaveDir, 'String', dirName);
        etSaveDir_Callback(appData.ui.etSaveDir, eventdata)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbSaveCurrent_Callback(object, eventdata) %#ok<INUSD>
    if ( appData.analyze.isReadPic == 1 )
        picNo = appData.save.picNo;
%         picNo = appData.data.picNo;
    elseif ( appData.save.isSave == 1 && appData.analyze.isReadPic == 0 )
        picNo = appData.save.picNo - 1;
    else
        picNo = appData.save.picNo;
    end
    
    [savedData, atoms, back] = createSavedData(appData); %#ok<NASGU,ASGLU>
    if strcmp(appData.consts.runVer, 'online') %online version - use the 'saveDir' folder
        save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', 'atoms', 'back', appData.consts.saveVersion);
    else % offline version - use the 'readDir' folder
        save([appData.analyze.readDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', 'atoms', 'back', appData.consts.saveVersion);
    end
    
%     if ( ~isempty(appData.consts.LVFile) && strcmp(appData.consts.runVer, 'online') )
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(picNo) '.txt']); %#ok<NASGU>
%         if ( s == 0 )
%             warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%         end
%     end
    if ( strcmp(appData.consts.runVer, 'online') )
        ret = appData.data.LVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
        if ( ret == 0)
            warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
        end
    end
    
    set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
    
    if ( appData.analyze.isReadPic == 0)
        appData.save.picNo = picNo + 1;
        set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etPicNo_Callback(object, eventdata) %#ok<INUSD>
    val = str2double(get(object, 'String'));
    if ( isnan(val) || val <= 0 || floor(val) ~= val )
        set(object, 'String', num2str(appData.save.picNo));
        errordlg('Input must be positive integer','Error', 'modal');
    else
        appData.save.picNo = val;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sPicNo_Callback(object, eventdata) %#ok<INUSD>
    val = get(object, 'Value');
    if ( val == 0 )
        if ( appData.save.picNo > 1 )
            appData.save.picNo = appData.save.picNo - 1;
        end
    elseif ( val == 2 )
        appData.save.picNo = appData.save.picNo + 1;
    end
    set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    % setWinName(appData);
    set(object, 'Value', 1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbSave_Callback(object, eventdata) %#ok<INUSD>
    appData.save.isSave  = get(object, 'Value');
%     appData.analyze.isReadPic = 0;
%     set(appData.ui.tbReadPic, 'Value', 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etSaveDir_Callback(object, eventdata) %#ok<INUSD>
    appData.save.saveDir = get(object, 'String');
    [s, mess, messid] = mkdir(appData.save.saveDir); %#ok<NASGU>
    if ( s == 0 )
        warndlg(['Cannot open/create directory: ' mess], 'Warning', 'modal');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbRun_Callback(object, eventdata)  

appData.data.isRun  = get(object, 'Value');

if ( appData.data.isRun == 0 )
    return
end

% firstLoop = 1;
% i = 0; %safety
picPause = 0.5;
isLastLVData = 0;
isNewMeasurement = 0;
% saftyPause = 1;
while ( appData.data.isRun == 1 )%&& i < 10 )   
    %
    % read atoms, backgraund and dark images
    %
    
    fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  ...
        num2str(appData.data.camera.firstImageNo) '.' appData.data.camera.fileFormat];
    fid = fopen(fileName);
    while ( fid  == -1 && appData.data.isRun == 1)
        pause(picPause);
        fid = fopen(fileName);
    end
    if ( appData.data.isRun == 0 )
        return
    end
    fclose(fid); 
    pause(picPause);
%     appData.data.atoms = rot90( double(appData.data.camera.fileReadFunction(appData, 0)), appData.data.camera.rotate / 90);
    atoms = rot90( double(appData.data.camera.fileReadFunction(appData, appData.data.camera.firstImageNo)), ...
        appData.data.camera.rotate / 90);
    delete(fileName);
   
    fileName = [appData.data.camera.dir '\' appData.data.camera.fileName ...
        num2str(appData.data.camera.secondImageNo) '.' appData.data.camera.fileFormat];
    fid = fopen(fileName);
    while ( fid  == -1 && appData.data.isRun == 1)
        pause(picPause);
        fid = fopen(fileName);
    end
    if ( appData.data.isRun == 0 )
        return
    end
    fclose(fid);
    pause(picPause);
%     appData.data.back = rot90( double(appData.data.camera.fileReadFunction(appData, 1)), appData.data.camera.rotate / 90);
    back = rot90( double(appData.data.camera.fileReadFunction(appData, appData.data.camera.secondImageNo)), ...
        appData.data.camera.rotate / 90);
    delete(fileName);
    
%     appData.data.dark = double(imread([appData.data.camera.dir '\' appData.data.camera.darkPicStr]));
    appData.data.dark = 0;%zeros(size(atoms));
    
    if ( appData.loop.isLoop == 0 )
        appData.data.LVData = LVData.readLabview(appData.consts.defaultStrLVFile_Save);
        appData.data.lastLVData = appData.data.LVData;
    end

    %
    % Loop 
    %
    if ( appData.loop.isLoop == 1 )
        if isempty(appData.loop.measurements)
            warndlg('No More Measurements.', 'Warning', 'modal');
            set(appData.ui.tbLoop, 'Value', 0)
            tbLoop_Callback(appData.ui.tbLoop, eventdata);
%             firstLoop = 1;
            continue
        end
        
        % get next measurement
        appData.data.lastLVData = appData.data.LVData;
        [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
%         pmSaveParam_Callback(appData.ui.pmSaveParam, []);
%         etParamVal_Callback(appData.ui.etParamVal, []);
        
        if isempty(appData.data.LVData)
%             'empty' %#ok<NOPRT>
%              set(appData.ui.lbMeasurementsList, 'Value', 1);
             lbMeasurementsList_KeyPressFcn(appData.ui.lbMeasurementsList, struct('Key', 'removeFirst'));
                 
            if  isempty(appData.loop.measurements)         % TODO : move that part to after saving (so the last pic will be saved)       
                isLastLVData = 1;
                
%                 set(appData.ui.tbSave, 'Value', 0);
%                 tbSave_Callback(appData.ui.tbSave, eventdata)
                
%                 set(appData.ui.tbLoop, 'Value', 0);
%                 tbLoop_Callback(appData.ui.tbLoop, eventdata)
%                 
%                 appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
            else
                isNewMeasurement = 1;
                % start next measuremdent
                [appData.loop.measurements{1} appData.data.LVData] = appData.loop.measurements{1}.next(appData);
%                 pmSaveParam_Callback(appData.ui.pmSaveParam, []);
%                 etParamVal_Callback(appData.ui.etParamVal, []);
                
%                 set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
%                 etSaveDir_Callback(appData.ui.etSaveDir, []);
                appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
                appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
                set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
            end
        else
            set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
%             etSaveDir_Callback(appData.ui.etSaveDir, []);
            appData.data.LVData.writeLabview(appData.consts.defaultStrLVFile_Load); 
            appData.loop.measurementsList{1} = appData.loop.measurements{1}.getMeasStr(appData);
            set(appData.ui.lbMeasurementsList, 'String', appData.loop.measurementsList);
            
%             if ( appData.save.isSave == 1 && strcmp(appData.consts.runVer, 'online') )
%                 ret = appData.data.LVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
%                 if ( ret == 0)
%                     warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%                 end
%             end
        end
    end
    
    
    %
    % Initialize data
    %

    appData.data.xPosMaxBack = 0;
    appData.data.yPosMaxBack = 0;
    
    appData.data.date = datestr(now);
    
    appData.data.fits = appData.consts.fitTypes.fits;
    appData.data.plots = appData.consts.plotTypes.plots;
%     appData.data.ROITypes = appData.consts.ROIUnits.ROITypes;

%     set(appData.ui.etComment, 'String', appData.consts.commentStr);
%     appData.save.commentStr = appData.consts.commentStr;

%     appData.save.saveOtherParamStr = appData.consts.saveOtherParamStr;
    
    %
    % Create absorption image
    %
    atoms = atoms - appData.data.dark;                           % subtract the dark background from the atom pic
    atoms = atoms .* ( ~(atoms<0));                                                   % set all pixelvalues<0 to 0
    back =  back - appData.data.dark;                              % subtract the dark background from the background pic
    back = back .* ( ~(back<0));                                                         % set all pixelvalues<0 to 0
%     appData.data.absorption = log( (back2 + (back2==0))./ (atoms2 + (atoms2==0))  );  % set all pixelvalues=0 to 1 and divide pics
    absorption = log( (back + 1)./ (atoms + 1)  );
%     appData.data.absorption = log( (back2 + 1)./ (atoms2 + 1)  );
    appData = appData.data.plots{appData.consts.plotTypes.withAtoms}.setPic(appData, atoms);
    appData = appData.data.plots{appData.consts.plotTypes.withoutAtoms}.setPic(appData, back);
    appData = appData.data.plots{appData.consts.plotTypes.absorption}.setPic(appData, absorption);
    appData = appData.data.plots{appData.consts.plotTypes.ROI}.setPic(appData, absorption);
    
    %
    % Smoothing
    %
    
%     %
%     % Check for saturation
%     %
%     binningFactor = 10;
%     binnedData = binning ( back, binningFactor);
% 
%     [maxes, indexes] = max(binnedData);
%     [maxValue, xPosMax] = max(maxes);
%     yPosMax = indexes(xPosMax);
%     if maxValue >= (2^appData.data.camera.bits*0.95)
%         appData.data.xPosMaxBack = binningFactor * (xPosMax - 0.5);
%         appData.data.yPosMaxBack = binningFactor * (yPosMax - 0.5);
%         msgbox({['Found mean value of: ' num2str(maxValue) ' in a region of 10 by 10 pixels.'] ...
%             ['The maximum value the camera can handle is: ' num2str(2^appData.data.camera.bits) '.']}, ...
%             'CCD-Camera might be saturated!', 'warn', 'modal');
%     else
%         appData.data.xPosMaxBack = 0;
%         appData.data.yPosMaxBack = 0;
%     end
    
    %
    % Analyze and Plot
    %
    appData = analyzeAndPlot(appData);
    
    if ( appData.loop.isLoop == 1 )
        etSaveDir_Callback(appData.ui.etSaveDir, []);
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
    end
    if isNewMeasurement == 1
        isNewMeasurement = 0;
        pmSaveParam_Callback(appData.ui.pmSaveParam, []);
        etParamVal_Callback(appData.ui.etParamVal, []);
        set(appData.ui.etSaveDir, 'String', appData.loop.measurements{1}.baseFolder);
        etSaveDir_Callback(appData.ui.etSaveDir, []);
    end
    if isLastLVData == 1
        isLastLVData = 0;
        set(appData.ui.tbLoop, 'Value', 0);
        tbLoop_Callback(appData.ui.tbLoop, [])
        
        appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
    end
    
    
    
%     %
%     % Saving 
%     %
%     if ( appData.save.isSave == 1 )
%         savedData = createSavedData(appData); 
%         save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);
%             
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
%         if ( s == 0)
%             warndlg(['Cannot copy LabView file: ' mess], 'Warning', 'modal');
%         end
%         
%         set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
%         appData.save.picNo = appData.save.picNo + 1;
%         set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
%     end
    
    set(appData.ui.etComment, 'String', appData.consts.commentStr);
    appData.save.commentStr = appData.consts.commentStr;
    
    %
    % Monitoring
    %
    

    
%     pause(saftyPause);
%     i=i+1;
%     set(object, 'Value', 0); % stop running
end %while

%                 continue 
% set(appData.ui.pAnylize, 'Visible', 'on');
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function pbMonitoringSave_Callback(object, eventdata) %#ok<INUSD>
% export2wsdlg({'Monitoring Data:'}, {'monitoringData'}, {appData.monitoring.monitoringData});
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function tbMonitoringOnOff_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.isMonitoring = get(object, 'Value');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function cbOnlySavedPics_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.onlySavedPics = get(object, 'Value');
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function lbAvailableMonitoring_Callback(object, eventdata) %#ok<INUSD>
% appData.monitoring.currentMonitoring = get(object, 'Value');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lbAvailableAnalyzing_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.currentAnalyzing = get(object, 'Value');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbSaveToWorkspace_Callback(object, eventdata) %#ok<INUSD>
    tempLineSpec = appData.analyze.LineSpec;
    appData.analyze.LineSpec = appData.consts.pmLineSpec.SaveToWS;
    pbAnalyze_Callback(object, eventdata);
    appData.analyze.LineSpec = tempLineSpec;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pbPicToWorkspace_Callback(object, eventdata) %#ok<INUSD>
        assignin('base', 'pic', appData.data.plots{appData.data.plotType}.getPic() );
        externalFig = figure('FileName', [appData.analyze.readDir '\data-' num2str(appData.save.picNo) '.fig']);
        subplot1 = copyobj(appData.ui.plot,externalFig);
        colormap(jet(256));
        yPlot1 = copyobj(appData.ui.yPlot,externalFig);
        subplot1Pos = get(subplot1,'Position');
        yPlot1Pos = get(yPlot1,'Position');
        set(externalFig, 'Position', [subplot1Pos(1) subplot1Pos(2) subplot1Pos(3)+1.5*yPlot1Pos(3) 1.05*subplot1Pos(4)])
        
        spwidth = round(subplot1Pos(3)*0.5);
        height = round(subplot1Pos(4)*0.5);
        
        yp1Pos = get(yPlot1,'Position');
        ypwidth = round(yp1Pos(3)*0.5);
        
        spacing = 40;
        left = 5+1.5*spacing;
%         set(subplot1,'Position', [left 1.2*spacing spwidth height], 'YAxisLocation', 'Left', 'XAxisLocation', 'Bottom', 'XTick', 0.4:0.1:0.6, 'YTick', 1.3:0.1:1.9); left = left + spwidth;
%         set(yPlot1,'Position', [left 1.2*spacing ypwidth height], 'XAxisLocation', 'Bottom', 'Xtick', [0 0.25]); left = left + ypwidth + 2*spacing;
%         xlabel('x [mm]', 'Parent', subplot1);
%         ylabel('z [mm]', 'Parent', subplot1, 'rot', -90); set(get(subplot1,'YLabel'), 'Position', [0.2 1.6])
%         ylabel([], 'Parent', yPlot1);
        
        
        set(externalFig, 'Position', [50 50 5+spwidth+ypwidth+2*spacing height+1.5*spacing]);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pmLineSpec_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.LineSpec = get(object, 'Value');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbAnalyze_Callback(object, eventdata) %#ok<INUSD>
    for ( i = 1 : length(appData.analyze.currentAnalyzing) )
        switch appData.analyze.currentAnalyzing(i)
            case appData.consts.availableAnalyzing.picMean %picMean case is dealt within imaging.m since it requires several external functions
                PicMean(appData.analyze.readDir);
                set(appData.ui.etShowPicNo, 'String', num2str(1000));
                appData.analyze.showPicNo = 1000;
                set(appData.ui.tbReadPic, 'Value', 1); %'Press' the ReadPic button
                tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
                tbReanalyze_Callback(object, eventdata)
            otherwise
                appData = analyzeMeasurement(appData, i);
        end
    end
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReadPics_Callback(object, eventdata)
    if ( get(object, 'Value') == 0 )
        return;
    end
    appData.analyze.readDir = get(appData.ui.etReadDir, 'String');
    appData.analyze.totAppData = [];
    evalStr = get(appData.ui.etAnalyzePicNums, 'String');
    if isempty(evalStr)
        evalStr = 'all';
    end
    if strcmp(computer, 'MACI64')
        files = dir([appData.analyze.readDir '/data-*.mat']);
    else
        files = dir([appData.analyze.readDir '\data-*.mat']);
    end
    %         analyzePicNums = [1:length(files)];
    nums = zeros(1, length(files));
    for ( j = 1 : length(files) )
        dotIndex = find(files(j).name == '.');
        dashIndex = find(files(j).name == '-');
        if ( length(dashIndex) == 1 )
            nums(j) = str2double(files(j).name(dashIndex(1)+1 : dotIndex(end)-1));
        else
            nums(j) = str2double(files(j).name(dashIndex(1)+1 : dashIndex(2)-1));
        end
    end
    if strcmp(evalStr, 'all')
        analyzePicNums = sort(nums); % list of existing mat files 
%         analyzePicNums = analyzePicNums(analyzePicNums<1000); %skip any pic with num>999 (used for averaged pic) in the 'all' case
        analyzePicNums = analyzePicNums(~isnan(analyzePicNums)); %to remove data-(PicNo)_custom.mat files
        fullEval = 0;
    elseif ( evalStr(1) == 'f' )
        analyzePicNums = eval([ '[' evalStr(2:end)  ']' ]);
        fullEval = 1;
    else
        analyzePicNums = eval([ '[' evalStr  ']' ]);
        analyzePicNums = analyzePicNums(ismember(analyzePicNums,nums)); %reduce user input vecotr only to existing mat files - thius is omportant in order to avoid bad points in the analyzeMeasurement.m results
        fullEval = 0;
    end
    if isempty(analyzePicNums)
        errordlg('Input must be an array','Error', 'modal');
    end
    totAppData = cell(1, length(analyzePicNums) );
    tmpIsReadPic = appData.analyze.isReadPic;
    appData.analyze.isReadPic = 1;
    set(appData.ui.tbReadPic, 'Value', appData.analyze.isReadPic);
    for ( i = 1 : length(analyzePicNums) )
        if ( get(object, 'Value') == 0 )
            break
        end
        num = analyzePicNums(i);
        set(appData.ui.etShowPicNo, 'String', num2str(num))
        drawnow;
        etShowPicNo_Callback(appData.ui.etShowPicNo, eventdata);
        
        totAppData{i} = appData;
        totAppData{i}.analyze = [];
        totAppData{i}.oldAppData = [];
        if ( fullEval == 0 )
            totAppData{i}.data.plots = appData.consts.plotTypes.plots;
            totAppData{i}.data.LVData = [];
            totAppData{i}.data.lastLVData = [];
            totAppData{i}.data.firstLVData = [];
        end
    end
    appData.analyze.totAppData = totAppData;
    appData.analyze.isReadPic = tmpIsReadPic;
    set(appData.ui.tbReadPic, 'Value', appData.analyze.isReadPic);
    set(object, 'Value', 0);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etShowPicNo_Callback(object, eventdata) 
    val = str2double(get(object, 'String'));
    if ( isnan(val) || val <= 0 || floor(val) ~= val )
        set(object, 'String', num2str(appData.analyze.showPicNo));
        errordlg('Input must be positive integer','Error', 'modal');
    else
        appData.analyze.showPicNo = val;
        tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sShowPicNo_Callback(object, eventdata) 
    
    %finds image numbers, in order to enable skipping non-exisiting pic
    %nums
    files = dir([appData.analyze.readDir '\data-*.mat']);
    nums = zeros(1, length(files));
    for j = 1 : length(files)
        dotIndex = find(files(j).name == '.');
        dashIndex = find(files(j).name == '-');
        if ( length(dashIndex) == 1 )
            nums(j) = str2double(files(j).name(dashIndex(1)+1 : dotIndex(end)-1));
        else
            nums(j) = str2double(files(j).name(dashIndex(1)+1 : dashIndex(2)-1));
        end
    end
    nums = sort(nums);

    val = get(object, 'Value');
    if ( val == 0 ) %decrease
        if ( appData.analyze.showPicNo > 1 )
            if isempty(max(nums(nums<appData.analyze.showPicNo)))
                appData.analyze.showPicNo = min(nums); %minimum reached or passed
            else
                appData.analyze.showPicNo = max(nums(nums<appData.analyze.showPicNo));
            end
        else
            return
        end
    elseif ( val == 2 ) %increase
        if isempty(min(nums(nums>appData.analyze.showPicNo)))
            appData.analyze.showPicNo = max(nums); %maximum reached or passed
        else
            appData.analyze.showPicNo = min(nums(nums>appData.analyze.showPicNo));
        end
    end
    set(appData.ui.etShowPicNo, 'String', num2str(appData.analyze.showPicNo));
    set(object, 'Value', 1);
    tbReadPic_Callback(appData.ui.tbReadPic, eventdata);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tbReadPic_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.isReadPic = get(object, 'Value');
    
    if ( appData.analyze.isReadPic == 0 )
        return
    end
    
    % MAC version
    % change also in tcReadPics_Callback (slash <-> back-slash):
%      if strcmp(evalStr, 'all')
%         files = dir([appData.analyze.readDir '/data-*.mat']);
%         ...
%     end
    if strcmp(computer, 'MACI64')
        savedData = tbReadPic_MAC(appData);
        appData = createAppData(savedData, appData);
        appData = analyzeAndPlot(appData);
        return
    end

    comment = [];
    fileName = ls([ appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '-*.mat']); %try reading filenames with a comment
    if ( size(fileName, 1) > 1 )
        fileName = strtrim(fileName(1, :));
    end
    if ( isempty(fileName) )
        fileName = ls([appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '.mat']); %uncommented filename
        if ( isempty(fileName) )
            warndlg({'File doesnt exist:', [appData.analyze.readDir '\data-' num2str(appData.analyze.showPicNo) '.mat']}, 'Warning', 'modal');
            return
        end
    else        
        dotIndex = find(fileName == '.');
        dashIndex = find(fileName == '-');
%         comment = fileName(dashIndex(end):dotIndex-1);
        comment = fileName(dashIndex(2):dotIndex(end)-1);
    end
    
    if  appData.options.doPlot == 1
        warning('off', 'MATLAB:load:variableNotFound')
        load([appData.analyze.readDir '\' fileName], 'savedData', 'atoms', 'back', 'optBack');
        if ~ (exist('atoms','var') || exist('back','var')) % if mat file is of the old type, in which 'atoms' and 'back' are inside 'savedData' - then move variables out of 'savedData', and save to drive
            atoms = savedData.atoms; back = savedData.back;  %#ok<NODEF>
            savedData = rmfield(savedData,{'atoms', 'back'});
            display([ 'fixing ' appData.analyze.readDir '\' fileName '...']);
            save([appData.analyze.readDir '\' fileName], 'savedData', 'atoms', 'back', appData.consts.saveVersion);
        end
        
    else %don't plot data - hence don't load 'atoms' and 'back' (to save time)
        load([appData.analyze.readDir '\' fileName], 'savedData');
    end
    if ( ~isempty(comment) )
        savedData.save.commentStr = comment;
    end
    if (length(appData.data.fits) > length(savedData.data.fits) )    
        savedData.consts.fitTypes = appData.consts.fitTypes;
        for j=length(savedData.data.fits)+1 : length(appData.data.fits) 
            savedData.data.fits{j} = appData.consts.fitTypes.fits{j};
        end        
    end
    if (length(appData.consts.availableAnalyzing.str) > length(savedData.consts.availableAnalyzing.str) )
        savedData.consts.availableAnalyzing = appData.consts.availableAnalyzing;
%         for i=length(savedData.data.fits)+1 : length(appData.data.fits) 
%             savedData.data.fits{i} = appData.data.fits{i};
%         end        
    end
    if  appData.options.doPlot == 1
%         if exist('optBack', 'var')
%             appData = createAppData(appData, savedData, atoms, optBack);
%         else
            appData = createAppData(appData, savedData, atoms, back);
%         end
    else
        appData = createAppData(appData, savedData, 0, 0);
    end
    appData = analyzeAndPlot(appData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etAnalyzePicNums_Callback(object, eventdata) %#ok<INUSD>
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pbOpenReadDir_Callback(object, eventdata)  %#ok<INUSL>
    dirName = uigetdir(get(appData.ui.etReadDir, 'String'));
    if ( dirName ~= 0 )
        set(appData.ui.etReadDir, 'String', dirName);
        etReadDir_Callback(appData.ui.etReadDir, eventdata)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function etReadDir_Callback(object, eventdata) %#ok<INUSD>
    appData.analyze.readDir = get(object, 'String');
end

end
% end imaging function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = idsReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsMain}) ~= 1 && ...
%         strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.idsSecond}) ~= 1 )
%     warndlg('Trying to read IDS file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = prosilicaReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilica}) ~= 1 )
%     warndlg('Trying to read Prosilica file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = prosilicaCReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.prosilicaC}) ~= 1 )
%     warndlg('Trying to read Prosilica-c file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% file = imread(fileName, appData.data.camera.fileFormat);
% file=file(:,:,1);
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function file = andorReadFunction(appData, num)
% if ( strcmp(appData.data.camera.string, appData.consts.cameraTypes.str{appData.consts.cameraTypes.andor}) ~= 1)
%     warndlg('Trying to read ANdor file.', 'Warning', 'nonmodal');
% end
% fileName = [appData.data.camera.dir '\' appData.data.camera.fileName  num2str(num) '.' appData.data.camera.fileFormat];
% % file = imread(fileName);
% fid = fopen(fileName);
% file = fread(fid, [512 512], 'uint32');
% fclose(fid);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function onlyPlot(appData)
%
% Plot image and results
%
try
    plotImage(appData);
catch ME
    msgbox({ME.message, ME.cause, 'file:', ME.stack.file, 'name:', ME.stack.name, 'line', num2str([ME.stack(:).line])}, ...
        'Cannot plot data!!!', 'error', 'modal');
end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function appData = analyzeAndPlot(appData)
% Analyze the absorption image
avgWidth = appData.options.avgWidth;%str2double(get(appData.ui.etAvgWidth, 'String'));
if ~isfield(appData.consts, 'maxAvgWidth')
    appData.consts.maxAvgWidth = 8;
end
% i = avgWidth+2;
% for (i = avgWidth+2 : 2 : avgWidth+appData.consts.maxAvgWidth)
    try
        if ( appData.data.fits{appData.data.fitType}.atomsNo == -1  || ...
                (  strcmp(appData.consts.runVer, 'offline') && appData.options.plotSetting == appData.consts.plotSetting.last ))
            appData = appData.data.fits{appData.data.fitType}.analyze(appData); %appData.data.fits{appData.data.fitType}.analyze(appData); %impose/enforce fit type for 'Re-analyze' here - e.g. SG with 12
            set(appData.ui.etAvgWidth, 'String', num2str(avgWidth));
            appData.options.avgWidth = avgWidth;
%             break;
        end
    catch ME
%         if ( i == avgWidth+8 )
            msgbox({ME.message, ME.cause, 'file:', ME.stack.file, 'name:', ME.stack.name, 'line', num2str([ME.stack(:).line])}, ...
                'Cannot analyze data!!!', 'error', 'modal');
            appData.data.fitType = appData.consts.fitTypes.onlyMaximum;
            set(appData.ui.pmFitType, 'Value', appData.data.fitType);
            appData = appData.data.fits{appData.data.fitType}.analyze(appData);
%         else        
%             set(appData.ui.etAvgWidth, 'String', num2str(i));
%             appData.options.avgWidth = i;
% 
%             tmpFitType = appData.data.fitType;
%             appData.data.fitType = appData.consts.fitTypes.onlyMaximum;
%             set(appData.ui.pmFitType, 'Value', appData.data.fitType);
%             appData = appData.data.fits{appData.data.fitType}.analyze(appData);     
%             onlyPlot(appData);
%             appData.data.fitType = tmpFitType;
%             set(appData.ui.pmFitType, 'Value', appData.data.fitType);
%         end
    end
% end

if  appData.options.doPlot == 1
    % Plot image and results
    onlyPlot(appData);
end

%
% Saving 
%
if ( appData.save.isSave == 1 )
    [savedData, atoms, back] = createSavedData(appData);  %#ok<NASGU,ASGLU>
    if strcmp(appData.consts.runVer, 'online') %online version - use the 'saveDir' folder
        save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', 'atoms', 'back', appData.consts.saveVersion);
    else % offline version - use the 'readDir' folder
        save([appData.analyze.readDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', 'atoms', 'back', appData.consts.saveVersion);
    end
    
%      save(['\\analysis\RawData\imaging-data.mat'], 'savedData', appData.consts.saveVersion);
    
%     if ( ~isempty(appData.consts.LVFile) && strcmp(appData.consts.runVer, 'online') )
%         [s m mid] = copyfile(appData.consts.LVFile, [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']); %#ok<NASGU>
%         if ( s == 0)
%             warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
%         end
%     end
    if ( strcmp(appData.consts.runVer, 'online') )
        ret = appData.data.lastLVData.writeLabview( [appData.save.saveDir '\data-' num2str(appData.save.picNo) '.txt']);
        if ( ret == 0)
            warndlg(['Cannot copy LabView file: ' m], 'Warning', 'modal');
        end
    end
   
    set(appData.ui.win, 'Name', [appData.consts.winName num2str(appData.save.picNo) appData.save.commentStr]);
    appData.save.picNo = appData.save.picNo + 1;
    set(appData.ui.etPicNo, 'String', num2str(appData.save.picNo));
    
% elseif ( appData.analyze.isReadPic == 1 )
%     savedData = createSavedData(appData); 
%     save([appData.save.saveDir '\data-' num2str(appData.save.picNo) appData.save.commentStr '.mat'], 'savedData', appData.consts.saveVersion);

end
% if appData.data.isLastLVData == 1
%     appData.data.isLastLVData = 0;
%     set(appData.ui.tbLoop, 'Value', 0);
%     tbLoop_Callback(appData.ui.tbLoop, [])
%     
%     appData.data.firstLVData.writeLabview(appData.consts.defaultStrLVFile_Load');
% end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function appData = updateROI(appData)
% [pic x0 y0] = appData.data.plots{appData.data.plotType}.getAnalysisPic(appData);
[pic x0 y0] = appData.data.plots{appData.consts.plotTypes.absorption}.getAnalysisPic(appData);
for ( i = 1 : length(appData.data.fits) )
    fitObj = appData.data.fits{i};
    
    if ( fitObj.atomsNo ~= -1 )
       [fitObj.ROILeft fitObj.ROITop fitObj.ROIRight fitObj.ROIBottom] = appData.data.ROITypes{appData.data.ROIUnits}.getROICoords(appData, fitObj);
       fitObj.atomsNo = appData.options.calcs{appData.options.calcAtomsNo}.calcAtomsNo(appData, fitObj, pic, ...
           [fitObj.ROILeft : fitObj.ROIRight] - x0+1, [fitObj.ROITop : fitObj.ROIBottom] - y0+1);  %#ok<*NBRAK>
       appData.data.fits{i} = fitObj;
    end
end
appData = appData.data.plots{appData.consts.plotTypes.ROI}.setPic(appData, pic);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [savedData, atoms, back] = createSavedData(appData)
savedData.consts = appData.consts;
savedData.data = appData.data;
savedData.options = appData.options;
savedData.save = appData.save;

% if ( appData.analyze.isReadPic == 0 )
%     savedData.data.picNo = appData.save.picNo;
%     savedData.data.saveParam = appData.save.saveParam;
%     savedData.data.saveParamVal = appData.save.saveParamVal;
% else
%     savedData.data.picNo = appData.data.picNo;
%     savedData.data.saveParam = appData.data.saveParam;
%     savedData.data.saveParamVal = appData.data.saveParamVal;
% end

%'atoms' and 'back' are now saved outside of 'savedData' variable, to increase loasing speed
atoms = uint16(savedData.data.plots{appData.consts.plotTypes.withAtoms}.getPic());
back = uint16(savedData.data.plots{appData.consts.plotTypes.withoutAtoms}.getPic());
savedData.dark = uint16(appData.data.dark);
savedData.data.plots = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newAppData = createAppData(appData, savedData, atoms, back) 
    newAppData = appData;
%     if ( isfield(appData, 'oldAppData') )
%         newAppData.oldAppData = appData.oldAppData;
%     else
%         newAppData.oldAppData = appData;
%     end

%     newAppData.consts = savedData.consts;
    newAppData.data = savedData.data;
    newAppData.options = savedData.options;
    newAppData.options.doPlot = appData.options.doPlot; %Fixes the fact that the saved data has overwrriten the doPlot (Update plot) variable.
    newAppData.save = savedData.save; 
    
    if  appData.options.doPlot == 1
    %
    % Create absorption image
    %
    atoms = double(atoms); %atoms = double(savedData.atoms);
    back = double(back); %back = double(savedData.back);
    newAppData.data.dark = double(savedData.dark);

    atoms = atoms - newAppData.data.dark;                                           % subtract the dark background from the atom pic
    atoms2 = atoms .* ( ~(atoms<0));                                                                                % set all pixelvalues<0 to 0
    back =  back - newAppData.data.dark;                                              % subtract the dark background from the background pic
    back2 = back .* ( ~(back<0));                                                                                      % set all pixelvalues<0 to 0
    absorption = log( (back2 + 1)./ (atoms2 + 1)  );
%     assignin('base','ratioTemp',mean2(double(atoms))/mean2(double(back)));
%     evalin('base','ratio = [ratio ratioTemp];');
    newAppData.data.plots = newAppData.consts.plotTypes.plots;
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.withAtoms}.setPic(newAppData, atoms);
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.withoutAtoms}.setPic(newAppData, back);
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.absorption}.setPic(newAppData, absorption);
%     newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);

    %
    % Set Pic data in the figure
    %
    
    % TODO: add option for saved or previos plot settings
    if ~isfield(appData.consts, 'plotSetting')
        appData.options.plotSetting = get(newAppData.ui.pmPlotSetting, 'Value');
        appData.consts.plotSetting.str = {'Default Setting', 'Last Setting'};
        appData.consts.plotSetting.defaults = 1;
        appData.consts.plotSetting.last = 2;
        appData.consts.plotSetting.default = 2;
    end
    switch appData.options.plotSetting
        case appData.consts.plotSetting.defaults % saved settings
            set(newAppData.ui.pmFitType, 'Value', newAppData.data.fitType);
            set(newAppData.ui.pmPlotType, 'Value', newAppData.data.plotType);
            set(newAppData.ui.pmROIUnits, 'Value', newAppData.data.ROIUnits);
            set(newAppData.ui.etROISizeX, 'String', num2str(newAppData.data.ROISizeX));
            set(newAppData.ui.etROISizeY, 'String', num2str(newAppData.data.ROISizeY));
            set(newAppData.ui.etROICenterX, 'String', num2str(newAppData.data.ROICenterX));
            set(newAppData.ui.etROICenterY, 'String', num2str(newAppData.data.ROICenterY));
            
            set(newAppData.ui.pmCalcAtomsNo, 'Value', newAppData.options.calcAtomsNo);
            set(newAppData.ui.etAvgWidth, 'String', num2str(newAppData.options.avgWidth));

%             set(newAppData.ui.etSaveDir, 'String', newAppData.save.saveDir);
            
        case appData.consts.plotSetting.last
            newAppData.data.fitType = get(newAppData.ui.pmFitType, 'Value');
            newAppData.data.plotType = get(newAppData.ui.pmPlotType, 'Value');
            newAppData.data.ROIUnits = get(newAppData.ui.pmROIUnits, 'Value');
            newAppData.data.ROISizeX = str2double(get(newAppData.ui.etROISizeX, 'String'));
            newAppData.data.ROISizeY = str2double(get(newAppData.ui.etROISizeY, 'String'));
            newAppData.data.ROICenterX = str2double(get(newAppData.ui.etROICenterX, 'String'));
            newAppData.data.ROICenterY = str2double(get(newAppData.ui.etROICenterY, 'String'));
            
%     newAppData.data.fitType = appData.data.fitType;
%     newAppData.data.plotType = appData.data.plotType;
%     newAppData.data.ROIUnits = appData.data.ROIUnits;
%     newAppData.data.ROISizeX = appData.data.ROISizeX;
%     newAppData.data.ROISizeY = appData.data.ROISizeY;
%     newAppData.data.ROICenterX = appData.data.ROICenterX;
%     newAppData.data.ROICenterY = appData.data.ROICenterY;

            newAppData.options.calcAtomsNo = get(newAppData.ui.pmCalcAtomsNo, 'Value');
            newAppData.options.avgWidth = str2double(get(newAppData.ui.etAvgWidth, 'String'));
            
            newAppData.data.fits = appData.consts.fitTypes.fits;

            newAppData.save.saveDir = get(newAppData.ui.etSaveDir, 'String');

    end
    tmpPlotType = newAppData.data.plotType;
    newAppData.data.plotType = newAppData.consts.plotTypes.absorption;
    newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);
    newAppData.data.plotType = tmpPlotType;
%     newAppData = newAppData.data.plots{newAppData.consts.plotTypes.ROI}.setPic(newAppData, absorption);
    end
    set(newAppData.ui.pmCameraType, 'Value', newAppData.options.cameraType);
    set(newAppData.ui.etDetuning, 'String', num2str(newAppData.options.detuning));
    set(newAppData.ui.etAvgWidth, 'String', num2str(newAppData.options.avgWidth));
    newAppData.options.plotSetting = appData.options.plotSetting;
    set(newAppData.ui.pmPlotSetting, 'Value', newAppData.options.plotSetting);

    set(newAppData.ui.etSaveDir, 'String', ''); %newAppData.save.saveDir
    set(newAppData.ui.etComment, 'String', newAppData.save.commentStr(2:end));
    set(newAppData.ui.etPicNo, 'String', ''); %num2str(newAppData.save.picNo)
    newAppData.save.isSave = appData.save.isSave;
    set(newAppData.ui.tbSave, 'Value', newAppData.save.isSave);
    set(newAppData.ui.pmSaveParam, 'Value', newAppData.save.saveParam);
    set(newAppData.ui.etParamVal, 'String', num2str(newAppData.save.saveParamVal));

    newAppData.consts.winName = appData.consts.winName;
    set(appData.ui.win, 'Name', [newAppData.consts.winName num2str(newAppData.save.picNo) newAppData.save.commentStr]);
    
    newAppData.consts.runVer = 'offline';
    
end