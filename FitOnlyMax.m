classdef FitOnlyMax < FitTypes
%FITONLYMAX Summary of this class goes here
%   Detailed explanation goes here

   properties ( Constant = true )
       ID = 'FitOnlyMax';
   end
   properties ( SetAccess = private)
       stdv = 0;
   end

   methods 
       function appData = analyze(obj, appData) % do the analysis
           [pic x0 y0] = appData.data.plots{appData.data.plotType}.getAnalysisPic(appData);
           [h w] = size(pic);
           %binning and max
           binW = appData.options.avgWidth;
           %            binnedData = binning ( pic, binW*2+1);
           binnedData = LowPassFilter(pic,30,3);
           [maxes, indexes] = max(binnedData);                     % find maximum
           [maxValue, xPosMax] = max(maxes);
           yPosMax = indexes(xPosMax);   
           obj.maxVal = maxValue;% / (appData.options.avgWidth*2)^2; %no need, already done in binning.m
           % center
           obj.xCenter = xPosMax + x0; %(binW*2+1) * (xPosMax ) + x0-binW;
           obj.yCenter = yPosMax + y0; %(binW*2+1) * (yPosMax ) + y0-binW; 
           % unit size
           obj.xUnitSize = w;
           obj.yUnitSize = h;   
           
%            obj.stdv = std(sqrt(pic(:).^2));
           obj.stdv = std(pic(:));
           
           % calc ROI size (use ROIUnits.m) - MUST be after fit
           [obj.ROILeft obj.ROITop obj.ROIRight obj.ROIBottom] = appData.data.ROITypes{appData.data.ROIUnits}.getROICoords(appData, obj);
           
           obj.atomsNo = appData.options.calcs{appData.options.calcAtomsNo}.calcAtomsNo(appData, obj, pic, ...
               [obj.ROILeft : obj.ROIRight] - x0+1, [obj.ROITop : obj.ROIBottom] - y0+1); 
           
           [xData yData] = appData.data.plots{appData.data.plotType }.getXYDataVectors(obj.xCenter, obj.yCenter, 0);
           
           obj.xData = xData;
           obj.xStart = x0;
           obj.yData = yData;
           obj.yStart = y0;
           
           % last
           % set ROI pic - MUST be after defining ROI
           appData.data.fits{appData.consts.fitTypes.onlyMaximum} = obj;
           appData = appData.data.plots{appData.consts.plotTypes.ROI}.setPic(appData, pic);
%            
%            % last 
%            appData.data.fits{appData.consts.fitTypes.onlyMaximum} = obj;
       end
       
       function normalizedROI = getNormalizedROI(obj, pic, x, y) % return normalized ROI (to the fitting constant)
           normalizedROI = pic(y, x);
       end
       
       function normalizedROI = getTheoreticalROI(obj, pic, x, y)
           normalizedROI = pic(y, x);
       end
       
       function normalizedPic = normalizePic(obj, pic)
           normalizedPic = pic/obj.maxVal;
       end
       
       function [xFit yFit] = getXYFitVectors(obj, x, y)
           xFit = zeros(size(x));
           yFit = zeros(size(y));
       end
       
       function  plotFitResults(obj, appData)  % plots the text
           [pic x0 y0] = appData.data.plots{appData.data.plotType}.getPic();
%            text( 10, 190, ['Atoms Num: ' num2str(obj.atomsNo/1e6) '*10^6'], 'fontSize', 20);
           text( 10, 190, ['Atoms Num: ' addCommas(obj.atomsNo)], 'fontSize', 20);
           
%                ['x_0 = ' num2str((obj.xCenter-x0+1) * appData.data.camera.xPixSz * 1000) ' mm'], ...-chipStart
%                ['y_0 = ' num2str((obj.yCenter-y0+1) *
%                appData.data.camera.yPixSz * 1000) ' mm']}, ...
           text( 50, 130, {['OD_ = ' num2str(obj.maxVal) ], ...
                ['x_0 = ' num2str((obj.xCenter) * appData.data.camera.xPixSz * 1000) ' mm'], ...
               ['y_0 = ' num2str((obj.yCenter-appData.data.camera.chipStart) * appData.data.camera.yPixSz * 1000) ' mm']}, ...
               'fontsize', 12);
           text(50, 80, ['std = ' num2str(obj.stdv)], 'fontsize', 12);
       end
       
   end
end 
