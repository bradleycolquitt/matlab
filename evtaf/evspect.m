function [sm,sp,t,f,ax]=evspect(file,fs,freqbnds,timbnds)
    [sm,sp,t,f]=evsmooth(file,fs,100,512,0.8,2,freqbnds(1),freqbnds(2));
    ax=imagesc(t,f,log(abs(sp)));
    if exist('timbnds')
        axis([timbnds freqbnds])
    end
        set(gca,'YD','n');
    xlabel('Time (s)');
    ylabel('Frequency Hz')';
    