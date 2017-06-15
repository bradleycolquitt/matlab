function [] = pj_clean(fileType,threshold,wind,numwind,numnote,catchSongs,varargin)
%Makes batch with non-song files removed (via cleandirAuto)
%Also optionally runs pj_makeRandBatch which creates a new batch
%of N random files from batch.keep.

% threshold is segmentation threshold for determining notes

% If fileType == 'wave', makes batch of all wave files.
% If fileType == 'cbin', makes batch of all cbin files.

% If catchSongs == 1, makes batch of keep files that were also catches.

% Makes a batch file of files specified by fileType

% Reasonable parameters
% threshld = 100000
% wind = 1
% numwind = 4
% numnote = 4
% cathSongs = 0
% filetype = cbin

if fileType == 'cbin'
    !ls *cbin > batch
end
if fileType == 'wave'
    !ls *wav > batch
end

batch = 'batch';

fid=fopen(batch,'r');
fkeep=fopen([batch,'.keep'],'w');
fdcrd=fopen([batch,'.dcrd'],'w');
disp(['working...']);

while (1)
    try
    fn=fgetl(fid);
    if (~ischar(fn))
        break;
    end
    if (~exist(fn,'file'))
        continue;
    end

    [pth,nm,ext]=fileparts(fn);
    if (strcmp(ext,'.ebin'))
        [dat,fs]=readevtaf(fn,'0r');
        sm=evsmooth(dat,fs,0.01);
    elseif(strcmp(ext,'.cbin'))
        [dat,fs]=ReadCbinFile(fn);
        dat = dat(:,1);
        sm=mquicksmooth(dat,fs);
    elseif(strcmp(ext,'.wav'))
        [dat,fs]=wavread(fn);
        sm=mquicksmooth(dat,fs);
    end
   
    [ons offs] = msegment(sm,fs,15,20,threshold);
    %filter vocalizations that are between 10 and 150ms
    durs = offs-ons;
    kills = find(durs>0.15);
    ons(kills)=[];
    offs(kills)=[];
    durs = offs-ons;
    kills = find(durs<0.01);
    ons(kills)=[];
    offs(kills)=[];
    
    keepit=0;
    if (length(ons) > numwind)
        for ii = 1:length(ons)
            p = find(abs(ons(ii:length(ons))-ons(ii))<=wind);
            if (length(p)>=numwind)
                keepit=keepit+1;
            end
        end
        if (keepit>=numnote)
            fprintf(fkeep,'%s\n',fn);
            %disp('keeping...');
        else
            fprintf(fdcrd,'%s\n',fn);
            %disp('discarding...');
        end
    else
        fprintf(fdcrd,'%s\n',fn);
        %disp('discarding...');
    end
    catch
        continue
    end
end
fclose(fid);fclose(fkeep);fclose(fdcrd);
disp(['done.']);

% Creates additional batch file containing only catch trials that were also
% kept
keepbatch = 'batch.keep';
if catchSongs == 1
    findcatch(keepbatch)
end
catchbatch = 'batch.keep.catch';


if length(varargin) == 1
    N = varargin{1};
    if catchSongs == 1
        pj_makeRandBatch(catchbatch,N)
    else
        pj_makeRandBatch(keepbatch,N)
    end
end
    

end

