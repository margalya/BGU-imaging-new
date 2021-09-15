function appData = analyzeMeasurement(appData, i)
% for ( i = 1 : length(appData.analyze.currentAnalyzing) ) %#ok<*NO4LP>
switch appData.analyze.currentAnalyzing(i)
    case appData.consts.availableAnalyzing.temperature
        temperature(appData.analyze.totAppData);
    case appData.consts.availableAnalyzing.gravity
        gravity(appData.analyze.totAppData);
    case appData.consts.availableAnalyzing.lifeTime1
        lifeTime1(appData.analyze.totAppData);
    case appData.consts.availableAnalyzing.lifeTime2
        lifeTime2(appData.analyze.totAppData);
    case appData.consts.availableAnalyzing.atomNo
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.atomsNo; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_atomNo.fig']);
        plotLineSpec(val, N, appData, i, 'Atoms Number')
    case appData.consts.availableAnalyzing.OD
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.maxVal; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_OD.fig']);
        plotLineSpec(val, N, appData, i, 'Max Val')
    case appData.consts.availableAnalyzing.xPos
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            %                     xPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.xCenter ...
            %                         * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
            xPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.xCenter ...
                * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
            if fitType==appData.consts.fitTypes.oneDGaussian %extract the non-rounded value (xCenter is rounded)
                xPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.xRes.x0 ...
                * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
            end
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_xPos.fig']);
        plotLineSpec(val, xPos, appData, i, 'X Position [mm]')
    case appData.consts.availableAnalyzing.yPos
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            %                     if isfield(appData.analyze.totAppData{j}.data.fits{ fitType }, 'y0')
            yPos(j) = (appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter-appData.analyze.totAppData{j}.data.camera.chipStart) ... %
                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            %                     else
            %                         yPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter ...
            %                             * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            %                     end
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_yPos.fig']);
        plotLineSpec(val, yPos, appData, i, 'Y Position [mm]')
    case appData.consts.availableAnalyzing.sizeX
        %             fitType = appData.analyze.totAppData{1}.data.fitType;
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            szX(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.sigmaX ...
                * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
            if any(fitType==[appData.consts.fitTypes.oneDBiModal appData.consts.fitTypes.twoDBiModal])
                szXTF(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.TFhwX ...
                * appData.analyze.totAppData{j}.data.camera.xPixSz *1000; %#ok<AGROW>
            end
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_sizeX.fig']);
        plotLineSpec(val, szX, appData, i, 'Size X [mm]')
        if exist('szXTF', 'var')
            figure( 'FileName', [appData.analyze.readDir '_sizeXTF.fig']);
            plotLineSpec(val, szXTF, appData, i, 'Thomas Fermi Size X [mm]')
        end
    case appData.consts.availableAnalyzing.sizeY
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            szY(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yUnitSize ... %alternatively: use '.sigmaY' - but its not defined for all functions!
                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            if any(fitType==[appData.consts.fitTypes.oneDBiModal appData.consts.fitTypes.twoDBiModal])
                szYTF(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.TFhwY ...
                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            end
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_sizeY.fig']);
        plotLineSpec(val, szY, appData, i, 'Size Y [mm]')
        if exist('szYTF', 'var')
            figure( 'FileName', [appData.analyze.readDir '_sizeYTF.fig']);
            plotLineSpec(val, szYTF, appData, i, 'Thomas Fermi Size Y [mm]')
        end
    case appData.consts.availableAnalyzing.BECfraction
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
%             ampTFx(j) = appData.analyze.totAppData{j}.data.fits{fitType}.ampTFx; %#ok<AGROW>
%             ampTFy(j) = appData.analyze.totAppData{j}.data.fits{fitType}.ampTFy; %#ok<AGROW>
%             ampGx(j) = appData.analyze.totAppData{j}.data.fits{fitType}.ampGx; %#ok<AGROW>
%             ampGy(j) = appData.analyze.totAppData{j}.data.fits{fitType}.ampGy; %#ok<AGROW>
            objT = appData.analyze.totAppData{j}.data.fits{fitType};
            BECfraction(j) = 1./ (1 + 5*(objT.ampG*objT.sigmaX*objT.sigmaY)./(objT.ampTF*objT.TFhwX*objT.TFhwY) ); %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_BEC fraction.fig']);
        plotLineSpec(val, BECfraction, appData, i, 'BEC fraction')
%         figure( 'FileName', [appData.analyze.readDir '_TF to Gauss x amplitudes ratio.fig']);
%         plotLineSpec(val, ampTFx./ampGx, appData, i, 'TF amplitude / Gaussian amplitude, x axis')
%         
%         figure( 'FileName', [appData.analyze.readDir '_TF to Gauss y amplitudes ratio.fig']);
%         plotLineSpec(val, ampTFy./ampGy, appData, i, 'TF amplitude / Gaussian amplitude, y axis')
    case appData.consts.availableAnalyzing.deltaY_2
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            Delta_Y2(j) = 0.5*abs(appData.analyze.totAppData{j}.data.fits{ fitType }.y02-appData.analyze.totAppData{j}.data.fits{ fitType }.y01)...
                * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_deltaY.fig']);
        plotLineSpec(val, Delta_Y2, appData, i, '\Deltay/2  [mm]')
%     case appData.consts.availableAnalyzing.picMean %dealt within
%     imaging.m
    case appData.consts.availableAnalyzing.SG
        N=[];
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.mF1*100; %#ok<AGROW>
            
            x01(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.x01 * appData.analyze.totAppData{j}.data.camera.xPixSz * 1000; %#ok<AGROW>
            y01(j) = ( appData.analyze.totAppData{j}.data.fits{ fitType }.y01 - appData.analyze.totAppData{j}.data.camera.chipStart ) ... %
                * appData.analyze.totAppData{j}.data.camera.yPixSz * 1000; %#ok<AGROW>
            sigmaX1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.sigmaX1 * appData.analyze.totAppData{j}.data.camera.xPixSz * 1000; %#ok<AGROW>
            sigmaY1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.sigmaY1 * appData.analyze.totAppData{j}.data.camera.yPixSz * 1000; %#ok<AGROW>
            
            x02(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.x02 * appData.analyze.totAppData{j}.data.camera.xPixSz * 1000; %#ok<AGROW>
            y02(j) = ( appData.analyze.totAppData{j}.data.fits{ fitType }.y02 - appData.analyze.totAppData{j}.data.camera.chipStart ) ... %
                * appData.analyze.totAppData{j}.data.camera.yPixSz * 1000; %#ok<AGROW>
            sigmaX2(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.sigmaX2* appData.analyze.totAppData{j}.data.camera.xPixSz * 1000; %#ok<AGROW>
            sigmaY2(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.sigmaY2* appData.analyze.totAppData{j}.data.camera.yPixSz * 1000; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = checkVal(val, appData);
        
        figure( 'FileName', [appData.analyze.readDir '_SGxPos1.fig']);
        plotLineSpec(val, x01, appData, i, 'X Position [mm]')
        figure( 'FileName', [appData.analyze.readDir '_SGxPos2.fig']);
        plotLineSpec(val, x02, appData, i, 'X Position [mm]')
        
        figure( 'FileName', [appData.analyze.readDir '_SGyPos1.fig']);
        plotLineSpec(val, y01, appData, i, 'Y Position [mm]')
        figure( 'FileName', [appData.analyze.readDir '_SGyPos2.fig']);
        plotLineSpec(val, y02, appData, i, 'Y Position [mm]')
        
        figure( 'FileName', [appData.analyze.readDir '_SGsizeX1.fig']);
        plotLineSpec(val, sigmaX1, appData, i, 'Size X [mm]')
        figure( 'FileName', [appData.analyze.readDir '_SGsizeX2.fig']);
        plotLineSpec(val, sigmaX2, appData, i, 'Size X [mm]')
        
        figure( 'FileName', [appData.analyze.readDir '_SGsizeY1.fig']);
        plotLineSpec(val, sigmaY1, appData, i, 'Size Y [mm]')
        figure( 'FileName', [appData.analyze.readDir '_SGsizeY2.fig']);
        plotLineSpec(val, sigmaY2, appData, i, 'Size Y [mm]')
        
    case appData.consts.availableAnalyzing.mF1
        N=[];
        skippedFiles = {};
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            if (fitType == appData.consts.fitTypes.SG)
                N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.mF1*100; %#ok<AGROW>
            else
                N(j) = NaN; %#ok<AGROW> %set NaN for unfitted results
                skippedFiles = [skippedFiles ; num2str(appData.analyze.totAppData{j}.save.picNo)];
            end
        end
        if ~isempty(skippedFiles)
            val( isnan(N) ) =[]; %remove NaNs
            N( isnan(N) ) =[];
            msgbox(['Skipped files:'; skippedFiles])
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_mF1.fig']);
        plotLineSpec(val, N, appData, i, 'mF1 [%] ')
        %                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
        %                 xlabel(xlabelstr{appData.analyze.totAppData{1}.save.saveParamVal});
        %                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
        %                 hh = figure('CloseRequestFcn', {@closeRequestFcn_Callback, appData.analyze.readDir, 'SG.fig'});
        %                 plot(val, N, 'o');
        %                 xlabel(xlabelstr{get(appData.ui.pmSaveParam, 'Value')});
        %                 ylabel('mF=1 Percentage [%]');
        %                 saveas(hh, [appData.analyze.readDir '\SG_tmp.fig']);
        %                 plotSG({appData.analyze.readDir})
        %                 plotSG(val, N, appData.analyze.readDir);
    case appData.consts.availableAnalyzing.mF1RabiFreq
        N=[];
        skippedFiles = {};
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            if (fitType == appData.consts.fitTypes.SG)
                N(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.mF1*100; %#ok<AGROW>
            else
                N(j) = NaN; %#ok<AGROW> %set NaN for unfitted results
                skippedFiles = [skippedFiles ; num2str(appData.analyze.totAppData{j}.save.picNo)];
            end
        end
        if ~isempty(skippedFiles)
            val( isnan(N) ) =[]; %remove NaNs
            N( isnan(N) ) =[];
            msgbox(['Skipped files:'; skippedFiles])
        end
        val = checkVal(val, appData);
        val = val*1e6; %transform from MHz to Hz
        figure( 'FileName', [appData.analyze.readDir '_RabiVsFrequency.fig']);
        plotLineSpec(val, N, appData, i, 'mF1 [%] ');
        [ x, y ] = meanXAM( val, N);
        [x, Indx] = sort(x);
        y = y(Indx);
        %         s = fitoptions('Method','NonlinearLeastSquares', 'Startpoint', [max(y) 0 x(HWHM)/sqrt(log(2)) ]);
        GaussianFit = fit(x', y', 'gauss1');
        firstGuess = [0.9 1.3*GaussianFit.c1 GaussianFit.b1 0];
        lower = firstGuess*0.7; lower(4) = 0; lower(1) = 0;
        upper = firstGuess*1.3; upper(4) = 20; upper(1) = 1;
        fo = fitoptions('Method', 'NonlinearLeastSquares', 'Lower', lower, 'Upper', upper, 'Startpoint', firstGuess);
        ft = fittype('100*a*0.5*(fR^2/(fR^2+(f-f0)^2))*(1-cos(2*pi*sqrt((fR)^2+(f-f0)^2)*TR*1e-6))+c',...
            'coefficients', {'a', 'fR', 'f0',  'c'}, 'problem', {'TR'}, 'independent', 'f', 'dependent', 'y', 'options', fo);
        LVDataVar = LVData.readLabview([appData.analyze.totAppData{1}.save.saveDir '\data-' num2str(appData.analyze.totAppData{1}.save.picNo) appData.analyze.totAppData{1}.save.commentStr '.txt']);
        RFOnIndex = find([LVDataVar.eventsData(1,7 + 1).Digital_Channels{1,12 +1}(1,:).Value]);
        TR = LVDataVar.eventsData(1,7 + 1).Digital_Channels{1,12 +1}(1,RFOnIndex+1).Start - LVDataVar.eventsData(1,7 + 1).Digital_Channels{1,12 +1}(1,RFOnIndex).Start;
        RabiFit = fit(x', y', ft,'problem', {TR});
        
        hold on; plot(linspace(min(x)-0.5*range(x),max(x)+0.5*range(x)), RabiFit(linspace(min(x)-0.5*range(x),max(x)+0.5*range(x))), 'r')
        conf = calcBounds( RabiFit );
        text(0.02, 0.95, ['Resonance frequency = ' num2str(RabiFit.f0/1e6) '+/-' num2str(conf(3)/1e6) ' MHz'], 'Units', 'Normalized')
        text(0.02, 0.9, ['Rabi frequency = ' num2str(RabiFit.fR/1e3) '+/-' num2str(conf(2)/1e3) ' KHz'], 'Units', 'Normalized')
        text(0.02, 0.85, ['Required power for \pi pulse = ' 'DB'], 'Units', 'Normalized')

    case appData.consts.availableAnalyzing.SGyPos
        fitType = appData.analyze.totAppData{1}.data.fitType;
        for j= 1 : length(appData.analyze.totAppData)
            %                     if isfield(appData.analyze.totAppData{j}.data.fits{ fitType }, 'y0')
            switch fitType
                case appData.consts.fitTypes.SG
                    yPos1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y01 ...
                        * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                    yPos2(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y02 ...
                        * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                case appData.consts.fitTypes.twoDGaussian
                    yPos1(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.y0 ...
                        * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
                    yPos2(j) = yPos1(j); %#ok<AGROW>
            end
            %                     else
            %                         yPos(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.yCenter ...
            %                             * appData.analyze.totAppData{j}.data.camera.yPixSz *1000; %#ok<AGROW>
            %                     end
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
        end
        val = val*1e-3;
        val = checkVal(val, appData);
        s1 = fitoptions('Method','NonlinearLeastSquares', 'Startpoint', [0.02 1.51 0 70 0]);
        s2 = fitoptions('Method','NonlinearLeastSquares', 'Startpoint', [0.01 2.06 0 100 0]);
        f1 = fittype('a*sin(2*pi*f*(x - p))+c+d*x', 'coefficients', {'a', 'c', 'd', 'f',  'p'}, 'independent', 'x', 'dependent', 'y', 'options', s1);
        f2 = fittype('a*sin(2*pi*f*(x - p))+c+d*x', 'coefficients', {'a', 'c', 'd', 'f',  'p'}, 'independent', 'x', 'dependent', 'y', 'options', s2);
        [out1.res, out1.gof, out1.output] = fit(val', yPos1', f1);
        [out2.res, out2.gof, out2.output] = fit(val', yPos2', f2);
        
        [~, name, ~] = fileparts(appData.analyze.readDir);
        export2wsdlg({'mF=1:' 'mF=2:'}, {[name '_mF1'] [name '_mF2']}, {out1 out2});
        
        figure( 'FileName', [appData.analyze.readDir '_mF1.fig']);
        plot(out1.res, 'r', val, yPos1, 'ob');
        title(['mF=1, (' name ')'], 'interpreter', 'none');
        xlabel('time [ms]');
        ylabel('Y Position [mm]');
        legend({['mF=1, (' name ')'],['fit mF=1, (' name ')']},'interpreter', 'none');
        figure( 'FileName', [appData.analyze.readDir '_mF2.fig']);
        plot(out2.res, 'b', val, yPos2, 'or');
        title(['mF=2, (' name ')'], 'interpreter', 'none');
        xlabel('time [ms]');
        ylabel('Y Position [mm]');
        legend({['mF=2, (' name ')'], ['fit mF=2, (' name ')']},'interpreter', 'none');
        
        %                 [path, name, ext] = fileparts(appData.analyze.readDir);
        %                 export2wsdlg({'mF=1:' 'mF=2:'}, {[name '_mF1'] [name '_mF2']}, {out1 out2});
        
    case appData.consts.availableAnalyzing.lambda
        lambda=[];
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            if fitType==appData.consts.fitTypes.fringesY || fitType==appData.consts.fitTypes.fringesYChirp
            lambda(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.lambda* ...
                appData.analyze.totAppData{j}.consts.cameras{appData.analyze.totAppData{j}.options.cameraType}.yPixSz*1e6; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            else
                display( [ 'Pic number: ' num2str(appData.analyze.totAppData{j}.save.picNo) ', fit type incorrect'] )
            end
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_lambda.fig']);
        plotLineSpec(val, lambda, appData, i, '\lambda [\mum] ')
        %                 xlabelstr =   get(appData.ui.pmSaveParam, 'String');
        %                 xlabel(xlabelstr{appData.analyze.totAppData{1}.save.saveParamVal});
    case appData.consts.availableAnalyzing.phi
        phi=[];
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
%             lambda(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.lambda; %#ok<AGROW>
%             x0(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.x0; %#ok<AGROW>
            phi(j) = mod(appData.analyze.totAppData{j}.data.fits{ fitType }.res.phi, 2*pi); %#ok<AGROW>
            %                                 phi(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.phi; %#ok<AGROW>
            %                 dphi(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.conf(2) ; %#ok<AGROW> confidence bound of phase
            %                 OD(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.maxVal;
            v(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.v; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            %                 ROICy(j) = appData.analyze.totAppData{j}.data.ROICenterY;
%             ROIYCenter(j) = ((appData.analyze.totAppData{j}.data.fits{ fitType }.ROITop+appData.analyze.totAppData{j}.data.fits{ fitType }.ROIBottom)/2-appData.analyze.totAppData{j}.data.camera.chipStart)*appData.analyze.totAppData{j}.data.camera.yPixSz*1e3;
        end
        val = checkVal(val, appData);
        %             assignin('base','ROICy',ROICy);
        figure( 'FileName', [appData.analyze.readDir '_phi.fig']);
        [val, sortIndx] = sort(val);
        phi = phi(sortIndx);
        plotLineSpec(val, unwrap(phi), appData, i, 'phi [rad] ') % the phase obtained from - 2*pi/lambda.*x0
        % fit which is relative to the gaussian envelope, is shifted to absolute phase according to
        % phi_abs = phi_rel - k*x0
        %             figure;plot(val,dphi,'o');title('phase fit error')
        %             errorbar(val,  phi, dphi, 'o');
        %             [minS, dS] = minstd( phi, dphi);
        %             display(['Standard deviation of phase = ' num2str(minS) ' +/- ' num2str(dS)])
        %             xlabelstr =   get(appData.ui.pmSaveParam, 'String');
        %             xlabel(xlabelstr{appData.analyze.totAppData{1}.save.saveParamVal});
                figure( 'FileName', [appData.analyze.readDir '_phi_polar.fig']);
                polar(phi, v, 'o');
%         assignin('base','ROIYCenter',ROIYCenter(1));
    case appData.consts.availableAnalyzing.visibility
        v=[];
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            try
            v(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.v; %#ok<AGROW>
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            catch
                display(num2str(appData.analyze.totAppData{j}.data.picNo))
            end
            % put fit error bars on individual measurements:
%             tmpconfint = confint( appData.analyze.totAppData{j}.data.fits{ fitType }.res );
% %                     find index of the visibility parameter (changed in different versions of FitFringesY.m)
%             visIndx = find(strcmp(coeffnames( appData.analyze.totAppData{j}.data.fits{ fitType }.res ),'v'));
%             visPicMeanconf(j) = (tmpconfint(2,visIndx)-tmpconfint(1,visIndx))/2; %visPicMeanconf
        end
        val = checkVal(val, appData);
        figure( 'FileName', [appData.analyze.readDir '_visibility.fig']);
        plotLineSpec(val, v, appData, i, 'visibility ')
%         errorbar(val,v,visPicMeanconf,'o')
    case appData.consts.availableAnalyzing.NormVis
        v=[];
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            v(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.res.v; %#ok<AGROW>
        end
        VisMean = mean(v);
        VisSEM = std(v) / sqrt(length(v));
        load( [ appData.analyze.readDir '\data-1000.mat' ],'savedData');
        visPicMean = savedData.data.fits{ savedData.data.fitType }.res.v; %visPicMean
        tmpconfint = confint( savedData.data.fits{ savedData.data.fitType }.res );
        %         find index of the visibility parameter (changed in different versions of FitFringesY.m)
        visIndx = find(strcmp(coeffnames( savedData.data.fits{ savedData.data.fitType }.res ),'v'));
        visPicMeanconf = (tmpconfint(2,visIndx)-tmpconfint(1,visIndx))/2; %visPicMeanconf
        Vn = visPicMean./VisMean; %Normalized visibility
        VnErr = Vn .* sqrt( (visPicMeanconf./visPicMean).^2 + (VisSEM./VisMean).^2);
        display( ['Vn = ' num2str(Vn) ' +/- ' num2str(VnErr)] );
    case appData.consts.availableAnalyzing.Chirp
        for j= 1 : length(appData.analyze.totAppData)
            fitType = appData.analyze.totAppData{j}.data.fitType;
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            try
                deltaLambdaOverLambda(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.deltaLambdaOverLambda; %#ok<AGROW>
            catch
                deltaPhi(j) = appData.analyze.totAppData{j}.data.fits{ fitType }.deltaPhi; %#ok<AGROW>
            end
        end
        val = checkVal(val, appData);
        if exist('deltaLambdaOverLambda', 'var')
            figure( 'FileName', [appData.analyze.readDir '_chirp.fig']);
            plotLineSpec(val, deltaLambdaOverLambda, appData, i, '\Delta\lambda/\lambda (for +/- \sigma from center) ')
        else
            figure( 'FileName', [appData.analyze.readDir '_chirp.fig']);
            plotLineSpec(val, deltaPhi, appData, i, '\Delta\phi (\sigma from center) [rad]')
        end
    case appData.consts.availableAnalyzing.SaveParamVal
        for j= 1 : length(appData.analyze.totAppData)
            val(j) = appData.analyze.totAppData{j}.save.saveParamVal; %#ok<AGROW>
            picNo(j) = appData.analyze.totAppData{j}.save.picNo;
        end
        figure( 'FileName', [appData.analyze.readDir '_saveParamVal.fig']);
        plotLineSpec(picNo, val, appData, i, 'Save param value')
        if appData.analyze.LineSpec~=appData.consts.pmLineSpec.SaveToWS
            xlabel('Pic number')
        else
            evalin('base','picNo = x;clear(''x'');')
        end
    case appData.consts.availableAnalyzing.analyzeFolders
        analyzeFoldersGUI( appData)
    otherwise
        errordlg({'Not a known Value in \"imaging.m/pbSaveToWorkspace_Callback\".' ['appData.analyze.currentAnalyzing(' num2str(i)  ...
            ') is: ' num2str(appData.data.fitType)]},'Error', 'modal');
end
end

function plotLineSpec( x, y, appData, i, yLabel)
% x,y return variables are the plotted vectors
switch appData.analyze.LineSpec
    case appData.consts.pmLineSpec.o
        plot(x, y, appData.consts.pmLineSpec.str{appData.analyze.LineSpec} )
        xlabel('Param Value');
        ylabel(yLabel);
    case { appData.consts.pmLineSpec.oHyphen ; appData.consts.pmLineSpec.Hyphen}
        [x, Indx] = sort(x);
        y = y(Indx);
        plot(x, y, appData.consts.pmLineSpec.str{appData.analyze.LineSpec} )
        xlabel('Param Value');
        ylabel(yLabel);
    case appData.consts.pmLineSpec.oMeanStd % mean +/- standard deviation
        LineSpec = appData.consts.pmLineSpec.str{appData.analyze.LineSpec};
        LineSpec = strrep(LineSpec,', mean+/-std',''); %remove ' mean' from LineSpec string
        [ x_unique, yMean, yStd ] = meanXAM( x, y);
        errorbar(x_unique, yMean, yStd, LineSpec )
        xlabel('Param Value');
        ylabel( [yLabel '+/- std']);
    case appData.consts.pmLineSpec.oMeanSem % mean +/- standard error of the mean
        LineSpec = appData.consts.pmLineSpec.str{appData.analyze.LineSpec};
        LineSpec = strrep(LineSpec,', mean+/-sem',''); %remove ' mean' from LineSpec string
        [ x_unique, yMean, yStd, ySem ] = meanXAM( x, y);
        errorbar(x_unique, yMean, ySem, LineSpec )
        xlabel('Param Value');
        ylabel( [yLabel '+/- sem']);
    case appData.consts.pmLineSpec.AverageParam
        close(gcf);
        display( ['Mean ' appData.consts.availableAnalyzing.str{appData.analyze.currentAnalyzing(i)} ' = ' ...
            num2str(mean(y)) '; SEM = ' num2str( std(y)/sqrt(length(y)) ) '; std = ' num2str( std(y) )] );
    case appData.consts.pmLineSpec.SaveToWS
        close(gcf);
        assignin('base', 'x', x); %genvarname(['x_' appData.consts.availableAnalyzing.str{appData.analyze.currentAnalyzing(i)}])
        assignin('base', genvarname(appData.consts.availableAnalyzing.str{appData.analyze.currentAnalyzing(i)}), y);
end

end

function [ x_unique, yMean, yStd, ySem ] = meanXAM( x, y)
% meanXAM calcualtes the mean y value and its standard deviation, per value of x
% AM is for analyzeMeasurement.m function (to avoid duplication with the
% external meanX.m)

[x_unique,m,n]=unique(x);
yMean=zeros(1,length(m));
yStd=zeros(1,length(m));
ySem=zeros(1,length(m));
for j=1:length(m)
    yMean(j)=mean( y(n==j ));
    yStd(j)=std( y(n==j));
    ySem(j)=std( y(n==j))/sqrt(sum(n==j));
%     display(sum(n==j));
end

end

function val = checkVal(val, appData)
if ( min(val) == max(val) )
    for j= 1 : length(appData.analyze.totAppData)
        val(j) = appData.analyze.totAppData{j}.save.picNo;
    end
end
end
