function h5table = h5_2struct(h5_input)
%H5_2TABLE Creates a Table based on a h5 file
%    Input:
%       h5_info.Name - Name of the file
%       h5_info.Path - Path of the file
%   Output:
%       h5table      - Resulting table file

%% Main

h5_path_name = [h5_input.path,h5_input.name,'.h5'];                        % Full path to the H5 file (with extension)
h5_content   = h5info(h5_path_name);                                       % Content of H5 file
Table_names  = {h5_content.Groups.Name};                                   % Names of tables from H5 file
h5table      = struct;
for k_T = 1 : numel(Table_names)
    Table_names_clear           = erase(Table_names{k_T},'/');             % deleting "/" from the name of table
    h5table.(Table_names_clear) = table;                                   % empty table for converted H5 file
    Column_names                = {h5_content.Groups(1).Datasets.Name};    % e.g. Variables
    for k_C = 1 : numel(Column_names)                                      % over all columns
        h5table.(Table_names_clear).(Column_names{k_C}) = ...              % Reading the column values and
            h5read(h5_path_name,[Table_names{k_T},'/',Column_names{k_C}]); % assigning them to table 
    end                                                                    
end