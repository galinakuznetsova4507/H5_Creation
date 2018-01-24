%   The script is intended to converting a database to H5 format
%   (hierarchical, filesystem-like data format). 
%   *Maybe create a function of this script
%   Authors: Robert Brandalik 
%            Galina Kuznetsova

%% Clear start
clear all; 
clc

%% Setup
Input__filename = 'Example_FileFor_h5';
Output_filename = 'Example_File.h5';

%% Check if file exists
if exist(Output_filename,'file')
    m = input('Do you want to delete the old H5 file, Yes/No: ','s');      % Asking user if it is necessary 
    if strcmp (m,'Yes') == 1                                               % to delete the old H5 file
    delete(Output_filename);
            else
            disp ('Please rename the old H5 file');                        % Rename the file and run the code again
            return
    end
end
                
%% Read in Input File
data     = load(Input__filename);                                            % loading mat-file
Database = data.(cell2mat(fields(data)));                                    % call the loaded file 'Database'
TabInDB  = fields(Database);                                                 % Tables(fields) in Database DB
fid      = H5F.create(Output_filename);                                 	 % creation of H5 file

%% Creating the H5G group with names of subfiles 
for k_T = 1 : numel(TabInDB)                                             	 % over all Tables in DB
    group     = H5G.create(fid,TabInDB{k_T},1);                         	 % group of subfiles    
    table_val = Database.(TabInDB{k_T});                                     % values of all columns of the subfile;
    table_var = table_val.Properties.VariableNames;                          % variables in k_T Table
    % Creating the H5D Dataset with values of the table
    for k_V = 1 : numel(table_var)                                      	 % Variables in Tables 
        heading  = table_var{k_V};                                           % name of each column
        values   = table_val.(k_V);                                        	 % values of one column   
        if isnumeric(values)                                                 % TODO: only double values right now?
            type_id  = H5T.copy('H5T_NATIVE_DOUBLE');
            h5_dims  = fliplr(size(values));                                 	 % The HDF5 library uses C-style ordering 
                                                                                 % for multidimensional arrays, while MATLAB 
                                                                                 % uses FORTRAN-style ordering(see C vs Fortran memory order)
            space_id = H5S.create_simple(2,h5_dims,h5_dims);                     % create a new data space
            dset     = H5D.create(group,heading,type_id,space_id,'H5P_DEFAULT'); % create new Dataset for all values
            H5S.close(space_id);
            H5D.write(dset,'H5ML_DEFAULT','H5S_ALL','H5S_ALL',...                % write a data to Dataset
                'H5P_DEFAULT',values);
            H5D.close(dset);
        end
    end
    H5G.close(group);
end
H5F.close(fid);                                                              % Close connection