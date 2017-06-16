%list of stim times

for bsvl=1:length(sumbs)
    crbs=sumbs(bsvl);
    bsoutsh(bsvl).early=[];
    bsoutsh(bsvl).late=[];

    for shiftnum=1:length(crbs.shiftruns)
        shiftinds=crbs.shiftruns{shiftnum};
        
        ind_early=find(mod(crbs.tmvec(shiftinds,1),1)<(11/24));
        ind_late=find(mod(crbs.tmvec(shiftinds,2),1)>(15/24));
        if(~isempty(ind_early))
            bsoutsh(bsvl).early=[bsoutsh(bsvl).early makerow(shiftinds(ind_early))];
        end
        if(~isempty(ind_late))
            bsoutsh(bsvl).late=[bsoutsh(bsvl).late makerow(shiftinds(ind_late))];
        end
     
    end
    
end

for bsvl=1:length(phsumbs)
    crbs=phsumbs(bsvl);
    phbsout(bsvl).early=[];
    phbsout(bsvl).late=[];
    for shiftnum=1:length(crbs.shiftruns)
        shiftinds=crbs.shiftruns{shiftnum};
        ind_early=find(mod(crbs.rawtimes(shiftinds,1),1)<(11/24));
        ind_late=find(mod(crbs.rawtimes(shiftinds,2),1)>(15/24));
        if(~isempty(ind_early))
            phbsout(bsvl).early=[phbsout(bsvl).early makerow(shiftinds(ind_early))];
        end
        if(~isempty(ind_late))
            phbsout(bsvl).late=[phbsout(bsvl).late makerow(shiftinds(ind_late))];
        end
    end
    
end