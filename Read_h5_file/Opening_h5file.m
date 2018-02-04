%% Clear start

clear; close; clc

%% Read in h5 file

path_split  = strsplit(cd,'\');                                            % Split the path by "/"
addpath      ([strjoin(path_split,'\'),'\Subfunctions\']);                 % Adding a folder Subfunctions in current folder
    
h5_input.path = [strjoin(path_split(1:end),'\'),'\h5_files\'];             % Path to the folder with H5 files
h5_files_name = struct2table(dir(h5_input.path));                          % Content of folder h5_files (table)
h5_files_name = h5_files_name.name(h5_files_name.isdir ~= 1);              % Only files

All_Files = struct;                                                        % Initial struct file
for k = 1 : numel(h5_files_name)                                           % Over all files
    k_file_name   = strsplit(h5_files_name{k},'.');                        % Without extension
    h5_input.name = k_file_name{1};                                        % File Name
    h5table       = h5_2struct(h5_input);                                  % Read file as table
    All_Files.(k_file_name{1}) = h5table;                                  % Save table as struct field
    disp([num2str(k),'. File was read in.']);                              % Info message
end

