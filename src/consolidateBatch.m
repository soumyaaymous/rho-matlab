% AUTHOR: Kambadur Ananthamurthy
% Run this function to collect outputs from independent jobs and
% consolidate them into one file.
% cDate: Harvest Date
% cRun: Harvest Number

function consolidateBatch(cDate, cRun, workingOnServer)

tic

%% Directory config
configDir %in localCopies

%% Real and/or Synthetic Datasets Config
make_dbase %in localCopies

fprintf('Analyzing %s_%i_%i - Date: %s\n', ...
    dbase(1).mouseName, ...
    dbase(1).sessionType, ...
    dbase(1).session, ...
    dbase(1).date)
trialDetails = getTrialDetails(dbase(1));

%% Load Harvest config details
configHarvest

%% Consolidate analysis outputs
for job = 1:length(params)
    fprintf('Parsing output from job: %i\n', job)
    jobData = harvestAnalyzedData(db, params(job));
    if strcmpi(params(job).methodList, 'A')
        if ~params(job).trim
            cData.methodA.mAInput = jobData.mAInput;
            cData.methodA.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodA.holyData.mAInput = jobData.holyData.mAInput;
            cData.methodA.holyData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'B')
        if ~params(job).trim
            cData.methodB.mBInput = jobData.mBInput;
            cData.methodB.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodB.holyData.mBInput = jobData.holyData.mBInput;
            cData.methodB.holyData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'C')
        if ~params(job).trim
            cData.methodC.mCInput = jobData.mCInput;
            cData.methodC.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodC.holyData.mCInput = jobData.holyData.mCInput;
            cData.methodC.holyData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'D')
        if ~params(job).trim
            cData.methodD.mDInput = jobData.mDInput;
            cData.methodD.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodD.holyData.mDInput = jobData.holyData.mDInput;
            cData.methodD.holyData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'E')
        if ~params(job).trim
            cData.methodE.mEInput = jobData.mEInput;
            cData.methodE.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodE.holyData.mEInput = jobData.holyData.mEInput;
            cData.methodE.holyData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'F')
        if ~params(job).trim
            cData.methodF.mFInput = jobData.mFInput;
            cData.methodF.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodF.holyData.mFInput = jobData.holyData.mFInput;
            cData.methodF.holyData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    else
    end
end

filename = [db.mouseName '_' db.date '_synthDataAnalysis_' num2str(cDate) '_cRun' num2str(cRun) '_cData.mat' ];
fullPath4Save = strcat(saveFolder, filename);

disp('Saving everything ...')

save(fullPath4Save, 'cData', '-v7.3')
%save(fullPath4Save, 'cData')
disp('... done!')

% %Information about new file
% h5info(filename, saveFolder)
% h5disp(filename, saveFolder)

toc
disp('All done!')

end