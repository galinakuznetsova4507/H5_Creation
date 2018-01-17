%% TODO: 
%   *Short discription
%   *Maybe create a function of this script
%   *Add Authors
%   *Check if you satisfied with the comments in the Code. Be critical,
%   you can use your GitHub repository to show some future employer what
%   you did during your HiWi-Task. But stop at the point you feel annoyed 
%   with commenting.

%% Clear start
clear; clc

%% Setup
Input__filename = 'DB23_5min_res_2016';
Output_filename = 'Example_File.h5';

%% Check if file exists
if isfile(Output_filename)
    delete(Output_filename)     % TODO: Ask the user if he want to delete the file
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
            h5_dims  = fliplr(size(values));                                 	 % TODO: Explain why fliplr?
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