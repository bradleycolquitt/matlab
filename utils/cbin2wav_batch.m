function cbin2wav_batch(batch_file)
%
% writes the song waveform in a cbin file to a wav file specified by
% targetstr, or the cbin file's name + .wav if targetstr is empty
%

fid = fopen(batch_file,'rt');
while true
  thisline = fgetl(fid)
  if ~ischar(thisline); break; end  %end of file
  
  cbin2wav(thisline);
  
end
fclose(fid);

return;


%%
batch_file = 'batch.070817'
cbin2wav_batch(batch_file);