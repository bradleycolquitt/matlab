        

outcodelist=[]
ttime(1)=7.48+128/32000
NFFT=128;
fbins=[4500 8000]
fs=32000
ttime(2)=13.545+128/32000

tempvals1=[];
tempvals2=[];
Nbins=3

stimnames={'pu3bu86tw.wav' 'pu3bu86revtw.wav' 'pu3bu86m10tw.wav' 'pu3bu86p10tw.wav'}

for ii=1:length(fnames)
    for jj=1:length(ttime)

        dat=ReadCbinFile(fnames(ii).fn);
        dat=dat(:,1);

        inds=fix(ttime(jj)*fs)+[-(NFFT-1):0];
		dat2=dat(inds);
		fdat=abs(fft(hamming(NFFT).*dat2));

		ffv=get_fft_freqs(NFFT,fs);
		ffv=ffv(1:end/2);
		
		tempvals=[];
		
		inds2=find((ffv>=fbins(1))&(ffv<=fbins(2)));
		[y,i]=max(fdat(inds2));
		i=i+inds2(1)-1;
		i=i+[-Nbins:Nbins];
		if(jj==1)
            tempvals1=[sum(ffv(i).*fdat(i).')./sum(fdat(i))];
        else
           tempvals2=[sum(ffv(i).*fdat(i).')./sum(fdat(i))];
        end
    end

    if (tempvals1<5000)
        outcode=2;
    elseif (tempvals1>6500)&(tempvals1<7000)
        outcode=1;
    elseif(tempvals1>5000)&(tempvals1<6500)
        outcode=3;
    elseif(tempvals1>7000)
        outcode=4;
    else
        outcode=5;
    end
    outcodelist=[outcodelist outcode];
    pbfile=stimnames{outcode};

    cmd=['save -append ' fnames(ii).fn '.spk.mat pbfile'];
    eval(cmd);



end


    