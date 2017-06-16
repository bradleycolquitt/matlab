%% OBSOLETE - use readrecf instad.  I didn;'t realize it already saves trig note, so adding as as new field is not needed.
% ONE PROBLEM - does not write catch trials. But that is not possible to
% do, since catch is only determined after trigs are decided by labview and so there
% exist trigs (i.e. detects, regardless of whether pass FF threshold) that
% are detected offline, and therefore have no catch determination.

%% LT 12/7/14 - modified to additionalyl write:
% trignote (which template, from 0, 1, 2,...),
% FreqVals - offline calculated FF
% also:
%         rd.ttimesActualTrig=[];
%         rd.trignoteActualTrig=[];
%         rd.FreqValsActualTrig=[];
% These are offline calculated actual Trigs. I.e. should be identical to
% the real rec file (not X).

% This is called in EvTAFv4Sim_LT, whose output is to write a rec file with
% simulated stuff.

% to read the .rec file, use readrecf_LT_evtafv4

% -----------------------------------------

function wrtrecf(fname,recdata,ADDX);
%wrtrecf(fname,recdata,ADDX);
% wrtrecf(fname,recdata);
% recdata is a structure with all the rec file fields

if (~exist('ADDX'))
    ADDX=0;
else
    if (length(ADDX)==0)
        ADDX=0;
    end
end

pp = findstr(fname,'.rec');
if (length(pp)<1)
    pp2 = findstr(fname,'.');
    if (length(pp2)<1)
        recf = [fname,'.rec'];
    else
        recf = [fname(1:pp2(end)),'rec'];
    end
else
    recf = fname;
end

if (ADDX==1)
    pptmp=findstr(recf,'.rec');
    recf=[recf(1:pptmp(end)-1),'X.rec'];
end

fid = fopen(recf,'w');
if (isfield(recdata,'header'))
    for ii=1:length(recdata.header)
        fprintf(fid,'%s\n',recdata.header{ii});
    end
    fprintf(fid,'\n');
end

if (isfield(recdata,'adfreq'))
    fprintf(fid,'ADFREQ = %12.7e\n',recdata.adfreq);
end

if (isfield(recdata,'outfile'))
    fprintf(fid,'Output Sound File =%s\n',recdata.outfile);
end

if (isfield(recdata,'nchan'))
    fprintf(fid,'Chans = %d\n',recdata.nchan);
end

if (isfield(recdata,'nsamp'))
    fprintf(fid,'Samples = %d\n',recdata.nsamp);
end

if (isfield(recdata,'iscatch'))
    fprintf(fid,'Catch = %d\n',recdata.iscatch);
end

if (isfield(recdata,'tbefore'))
    fprintf(fid,'T BEFORE = %12.7e\n',recdata.tbefore);
end

if (isfield(recdata,'tafter'))
    fprintf(fid,'T AFTER = %12.7e\n',recdata.tafter);
end

if (isfield(recdata,'thresh'))
    fprintf(fid,'THRESHOLDS = ');
    for ii = 1:length(recdata.thresh)
        fprintf(fid,'\n%15.7e',recdata.thresh(ii));
    end
end
fprintf(fid,'\n');

if (isfield(recdata,'ttimes'))
    %fprintf(fid,'Trigger times = ');
    fprintf(fid,'Feedback information:\n\n');
    
    for ii = 1:length(recdata.ttimes)
        if (recdata.ttimes(ii)>=0)
            
            % going to assume that trignote is a field (using
            % EvTAFv4Sim_LT...)
            fprintf(fid,'\n%15.7e msec : FB',recdata.ttimes(ii));
            
            % CANNOT DO BELOW, since catch is only specified for online
            % hits.
            %             if recdata.catch(ii)==0; % i.e. not catch
            %                 fprintf(fid,'\n%15.7e msec : FB',recdata.ttimes(ii));
            %             elseif recdata.catch(ii)==0; % i.e. is catch
            %                 fprintf(fid,'\n%15.7e msec : catch',recdata.ttimes(ii));
            %             end
            
            %             fprintf(fid,' Templ = %d\n',recdata.trignote(ii));
            fprintf(fid,' Templ = %d',recdata.trignote(ii));
            
        end
    end
end
fprintf(fid,'\n');

%             if isfield(recdata,'trignote');
%                 fprintf(fid,'\nTemplate NoteNum:\n\n');
%
%                 for ii = 1:length(recdata.trignote)
%                     fprintf(fid,'TRIGNOTE = %d\n',recdata.trignote(ii));
%                 end
%             end



fclose(fid);
return;
