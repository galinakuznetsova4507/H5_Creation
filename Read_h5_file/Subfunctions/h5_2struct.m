function h5table = h5_2struct(h5_input)
%H5_2TABLE Creates an Table based on an h5 file
%    Input:
%       h5_info.Name - Name of the file
%       h5_info.Path - Path of the file
%   Output:
%       h5table      - Resulting table file

%% Main

h5_path_name = [h5_input.path,h5_input.name,'.h5'];
h5_content   = h5info(h5_path_name);
Table_names  = {h5_content.Groups.Name};
h5table      = struct;
for k_T = 1 : numel(Table_names)
    Table_names_clear           = erase(Table_names{k_T},'/');
    h5table.(Table_names_clear) = table;
    Column_names                = {h5_content.Groups(1).Datasets.Name};
    for k_C = 1 : numel(Column_names)
        h5table.(Table_names_clear).(Column_names{k_C}) = ...
            h5read(h5_path_name,[Table_names{k_T},'/',Column_names{k_C}]);
    end
end