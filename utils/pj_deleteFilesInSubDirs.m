%% Collects list of all subfolders, runs pj_cleanDir() in subfolders automatically

% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;

% Define a starting folder.
start_path = fullfile('/ibis3/PJ/Sequence/');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ':');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder]
end
numberOfFolders = length(listOfFolderNames)

% Run pj_cleanDir() in each subfolder
for k = 1 : numberOfFolders
    folder = listOfFolderNames{k}
    cd(folder);
    try
        disp('Deleting files...')
        pj_cleanDir()
    catch
        continue
    end
end