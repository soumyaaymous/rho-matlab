% Load the Consolidated Analysis Details and look for patterns in the plots

close all
%clear

tic

datasetCatalog = 1;

if datasetCatalog == 1
    input.cDate = 20220311;
    input.cRun = 1;
    input.nDatasets = 1;
    input.nMethods = 7; %Real datasets are not analyzed by SVM, currently.
    input.nAlgos = 13;
end

methodLabels = {'rR2B', 'Ispk', 'Isec', 'MI', 'pAUC', 'offPCA', 'Param.'};
algoLabels = {'rR2B-Bo', 'rR2B-Ot', 'Ispk-Bo', 'Isec-Bo', 'MI-Bo', 'Ispk-Ot', 'Isec-Ot', 'MI-Ot', 'pAUC-Bo', 'pAUC-Ot', 'offPCA-Ot', 'Param-Bo', 'Param-Ot'};

workingOnServer = 0;
% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end

addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))

make_db_realBatch %in localCopies

%Load analysis output
fullFilePath = sprintf('%srealDATA_Analysis_%i_cRun%i_cData.mat', saveDirec, input.cDate, input.cRun);
load(fullFilePath)

%allPredictors = [];
%allPredictions = [];

for dnum = 1:input.nDatasets
    
    %Load processed real data
    realProcessedData = load(strcat(saveDirec, db(dnum).mouseName, '_', db(dnum).date, '.mat'));
    DATA = realProcessedData.dfbf;
    DATA_2D = realProcessedData.dfbf_2D;
    input.nCells = size(DATA, 1);
    input.nTrials = size(DATA, 2);
    input.nFrames = size(DATA, 3);
    fprintf('Total cells: %i\n', input.nCells)
    
    %Consolidate scores
    predictors = getPredictors4RealData(cData, input, dnum);
    %allPredictors = [allPredictors; predictors];
    
    %Consolidate predictions
    predictions = getPredictions4RealData(cData, input, dnum);
    %allPredictions = [allPredictions; predictions];
end
%PLOTS
figureDetails = compileFigureDetails(11, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)

fig1 = figure(1);
set(fig1, 'Position', [100, 100, 1200, 600])
imagesc(zscore(predictors, 0))
title([db.mouseName ' ' db.date], ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xlabel('Methods', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xticks(1:input.nMethods)
xticklabels(methodLabels)
ylabel('Cells', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
z = colorbar;
ylabel(z, 'Z-Score', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
colormap(linspecer)
set(gca, 'FontSize', figureDetails.fontSize)

fig2 = figure(2);
set(fig2, 'Position', [100, 100, 1200, 600])
imagesc(predictions)
title([db.mouseName ' ' db.date], ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xlabel('Algorithms', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xticks(1:input.nAlgos)
xticklabels(algoLabels)
ylabel('Cells', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
z = colorbar;
ylabel(z, 'Is Time Cell?', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
colormap(gray)
set(gca, 'FontSize', figureDetails.fontSize)

elapsedTime3 = toc;
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime3)
disp('... All Done!')
