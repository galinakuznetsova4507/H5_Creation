%% TODO: 
%   *Short discription
%   *Maybe create a function of this script
%   *Add Authors

%% Clear start
clear; clc

%% Setup
Input__filename = 'Example_FileFor_h5';
Output_filename = 'Example_File.h5';

%% Check if file exists
if isfile(Output_filename)
    delete(Output_filename)     % TODO: Ask the user if he want to delete the file
end

%% Read in Input File
data     = load(Input__filename);                                           % loading mat-file
Database = data.(cell2mat(fields(data)));                                   % call the loaded file 'Database'
TabInDB  = fields(Database);                                                % Tables(fields) in Database DB
fid      = H5F.create(Output_filename);                                 	% creation of H5 file

%% Creating the H5G group with names of subfiles 
for i = 1 : length(TabInDB)                                                 % over all Tables in DB
    group       = H5G.create(fid,[TabInDB{i}],size(TabInDB{i},1));       	% group of subfiles    
    tablevalues = data.(cell2mat(fields(data))).(TabInDB{i});             	% values of all columns of the subfile
    info        = h5info(Output_filename);
    % Creating the H5D Dataset with values of the table
    for j = 1:size((tablevalues),2)
        heading   = cell2mat(tablevalues.Properties.VariableNames(1,j));    % name of each column
        parameter = tablevalues.(j);                                        % values of one column      
        type_id = H5T.copy('H5T_NATIVE_DOUBLE');                           
        h5_dims = fliplr(size(parameter));
        space_id = H5S.create_simple(2,h5_dims,h5_dims);                    % create a new data space
        dset = H5D.create(group,heading,type_id,space_id,...                % create new Dataset for all values
            'H5P_DEFAULT');  
        fileattrib(Output_filename,'+w');
        H5D.write(dset,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',...               % write a data to Dataset
            'H5P_DEFAULT',parameter);
        H5D.close(dset);       
    end
    H5G.close(group);
end
% Close connection
H5F.close(fid);