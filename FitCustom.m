classdef FitCustom < FitTypes
    % FitCustom is not a regular 'FitTypes' object - it calls a secondary fit object (defined in obj.baseFit), and uses it.
    % This enables to perform custom fits to different files, without inserting new fit types into the imaging software.
    
    properties ( Constant = true )
        ID = 'FitCustom';
    end
    properties (SetAccess = private )
        baseFit = [];
    end
    
    methods
        function appData = analyze(obj, appData) % do the analysis
            path(path, 'E:\Dropbox\MATLAB\imaging working copy\Custom Fits')
            %%% set fit type here - according to function name %%%
                        obj.baseFit = FitFringes_Vis_Lambda_Chirp;
%                         obj.baseFit = Fit21DGaussianTF;
%             obj.baseFit = FitFringesYChirp_v3_thermal;
            %%%%%%
            warning('off', 'MATLAB:class:cannotUpdateClass:Changed')
            appData = obj.baseFit.analyze(appData);
        end
        
        function normalizedROI = getNormalizedROI(obj, pic, x, y)
            normalizedROI = obj.baseFit.getNormalizedROI(obj, pic, x, y);
        end
        
        function normalizedROI = getTheoreticalROI(obj, pic, x, y)
            normalizedROI = obj.baseFit.getTheoreticalROI(obj, pic, x, y);
        end
        
        function normalizedPic = normalizePic(obj, pic)
            normalizedPic = obj.baseFit.normalizePic(obj, pic);
        end
        
        function [xFit, yFit] = getXYFitVectors(obj, x, y)
            [xFit, yFit] = obj.baseFit.getXYFitVectors(obj, x, y);
        end
        
        function  plotFitResults(obj, appData)
            obj.baseFit.plotFitResults(obj, appData);
        end
        
    end
end