%% BC - 6/14/17 - originally pj_cleanDir.m

function clean_song_dir()
%% Take no inputs. Delete from directory all .cbin files in batch.dcrd, and associated .rec and .tmp files.
% Used to delete 'noise' recordings and free up disk space. 

% Tip: Make sure batch.keep contains all desired files before running.

dcrd = fopen('batch.dcrd','r');

while (1)
    fn = fgetl(dcrd);
    fnNoExt = [fn(1:end-4),'*'];
    if (~ischar(fn))
        break;
    end
    if (~exist(fn,'file'))
        continue;
    end
    delete(fnNoExt)
end





