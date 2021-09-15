function [ ] = PicMean( folder )
%calculate average picture outside of imaging software. Does not load all
%files to memory.

matFiles = dir([folder '\*.mat']);
matFiles = matFiles( ~arrayfun(@(x) strcmp(x.name,'data-1000.mat'),matFiles) ); %remove data-1000.mat from the list
matFiles = matFiles( ~arrayfun(@(x) strcmp(x.name,'data-1001.mat'),matFiles) );

%sort files by pic number
% nums = zeros(1, length(matFiles));
% for j = 1 : length(matFiles)
%     dotIndex = find(matFiles(j).name == '.');
%     dashIndex = find(matFiles(j).name == '-');
%     if ( length(dashIndex) == 1 )
%         nums(j) = str2double(matFiles(j).name(dashIndex(1)+1 : dotIndex(end)-1));
%     else
%         nums(j) = str2double(matFiles(j).name(dashIndex(1)+1 : dashIndex(2)-1));
%     end
% end
% [~, Indx] = sort(nums);
% matFiles = matFiles(Indx);

load( [folder '\' matFiles(1).name] ); %load first file

newatoms = zeros(size( atoms )); %#ok<NODEF>
newback = newatoms;
% newabsorption = newatoms;
progressbar(0);
for j = 1 : length(matFiles)
    load( [folder '\' matFiles(j).name] );
    atomsTemp = double(atoms);
    backTemp = double(back); %#ok<NODEF>
    atomsTemp = atomsTemp .* ( ~(atomsTemp<0)); % set all pixelvalues<0 to 0
    backTemp = backTemp .* ( ~(backTemp<0)); % set all pixelvalues<0 to 0
    
    %add new file into the sum
    %     pic = pic + absorption;
    newatoms = newatoms + atomsTemp;
    newback = newback + backTemp;
    
    %create absorption and add to the sum
%     absorption = log( (newback + 1)./ (newatoms + 1)  );
%     newabsorption = newabsorption + absorption;
    
    progressbar(j/length(matFiles));
end

clear atoms back absoprtion
%divide by number of files (to average), and convert back to unit16
atoms = uint16(newatoms / length(matFiles)); %#ok<NASGU>
back = uint16(newback / length(matFiles)); %#ok<NASGU>
% absopriton = newabsorption / length(matFiles); %#ok<NASGU>

savedData.data.date = datestr(now);
savedData.save.picNo = 1000;

save( [folder '\data-' num2str(1000) '.mat'] ,'savedData', 'atoms', 'back') %, 'absopriton' can also be saved, if needed for averaging over absorption images and not on 'atoms' and 'back' images

end

