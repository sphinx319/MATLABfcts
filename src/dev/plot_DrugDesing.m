function plot_DrugDesing(Design)


for iD = 1:length(Design)
    
    get_newfigure(1e4+iD, [iD*50 20 700 600], 'Name', sprintf('Design #%i', iD))
    
    nDisp = length(Design(iD).Drugs);
    if isfield(Design(iD), 'Perturbations')
        nDisp = nDisp + length(Design(iD).Perturbations);
    end
    
    nCols = ceil(sqrt(nDisp));
    nRows = ceil(nDisp/nCols);
    
    xspacing = .03;
    axis_width = (1-(nCols+1)*xspacing)/nCols;
    yspacing = .1;
    axis_height = (1-(nRows+1)*yspacing)/nRows;
    
    colormap([.8 .1 .1; (1:-.01:0)'*[1 1 1]])
    
    for iDr = 1:length(Design(iD).Drugs)
        
        iC = mod(iDr-1, nCols)+1;
        iR = ceil(iDr/nCols);
        
        get_newaxes(axespos(iC, iR),1,...
            'fontsize',6);
        
        conc = log10(Design(iD).Drugs(iDr).layout);
        [range, conc] = DataRangeCap(conc);
        conc(~Design(iD).treated_wells) = NaN;
        
        imagesc(conc, range)
        
        title(Design(iD).Drugs(iDr).DrugName,'fontsize',8,'fontweight','bold')
        
        xlim([.5 Design(iD).plate_dims(2)+.5])
        ylim([.5 Design(iD).plate_dims(1)+.5])
        
        set(gca,'ytick',1:2:16, 'yticklabel', cellfun(@(x) {char(x)},num2cell(65:2:80)),...
            'xtick',1:3:30,'ydir','reverse')
    end
    
    
    if isfield(Design(iD), 'Perturbations')
        
        
        for iPr = 1:length(Design(iD).Perturbations)
            
            iC = mod(iPr-1+length(Design(iD).Drugs), nCols)+1;
            iR = ceil((iPr+length(Design(iD).Drugs))/nCols);
            
            get_newaxes(axespos(iC, iR),1,...
                'fontsize',6);
            
            conc = Design(iD).Perturbations(iPr).layout;
            if islogical(conc)
                conc = conc+1;
            elseif (max(conc(:))/min(conc(:)))>10 && max(conc(:))*min(conc(:))>=0
                conc = log10(conc);
            end
            [range, conc] = DataRangeCap(conc);
            
            imagesc(conc, range)
            
            title(Design(iD).Perturbations(iPr).Name,'fontsize',8,'fontweight','bold')
            
            xlim([.5 Design(iD).plate_dims(2)+.5])
            ylim([.5 Design(iD).plate_dims(1)+.5])
            
            set(gca,'ytick',1:2:16, 'yticklabel', cellfun(@(x) {char(x)},num2cell(65:2:80)),...
                'xtick',1:3:30,'ydir','reverse')
        end
        
    end
    
end



    function pos = axespos(iC, iR)
        pos = [xspacing*1.5+(iC-1)*(axis_width+xspacing) ...
            yspacing*1+(nRows-iR)*(axis_height+yspacing) axis_width axis_height];
    end

    function [range, conc] = DataRangeCap(conc)
        range = [min(conc(~isinf(conc))) max(conc(~isinf(conc)))];
        if range(1)==range(2)
            range = range+[-.1 .1];
        end
        conc(conc==-Inf) = min(conc(conc>-Inf)) -.2*diff(range);
        range = [range(1)-.3*diff(range) range(2)+.1*diff(range)];
    end

end