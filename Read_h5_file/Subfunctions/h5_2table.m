function h5table = h5_2table(h5_input)
%H5_2TABLE Creates an Table based on an h5 file
%    Input:
%       h5_info.Name - Name of the file
%       h5_info.Path - Path of the file
%   Output:
%       h5table      - Resulting table file

%% Main

h5_path_name = [h5_input.path,h5_input.name,'.h5'];
h5_content   = h5info(h5_path_name);
Table_names  = h5_content.Groups.Name;

h5_data      = h5read(h5_path_name,[h5_content.Groups.Name,'/',h5_content.Groups.Datasets.Name]);

h5table      = table;

Attributes_all   =  {h5_content.Groups.Datasets.Attributes.Name}';
Attributes       =  Attributes_all;                     
Attributes       = ...                                                      % Attributes contain information of measurement types
    Attributes(ismember(cellfun(@(x) x(end-3:end), Attributes,...
    'UniformOutput',0),'kind'));

for k = 1:numel(Attributes)
    if numel(size(h5_data.(Attributes{k}(1:end-5)))) ~= 2                   % 3D to 2D matrix (if necessary)
        temp_values = cell(size(h5_data.(Attributes{k}(1:end-5)),2),size(h5_data.(Attributes{k}(1:end-5)),3));
        for k_3 = 1 : size(h5_data.(Attributes{k}(1:end-5)),2)
            for k_4 = 1 : size(h5_data.(Attributes{k}(1:end-5)),3)
                temp_values(k_3,k_4) = {h5_data.(Attributes{k}(1:end-5))(:,k_3,k_4)'};
            end
        end
        h5_data.(Attributes{k}(1:end-5)) = temp_values;
    end
    pos_Attributes = ismember(Attributes_all,Attributes{k});                        
    original_name  = h5_content.Groups.Datasets.Attributes(pos_Attributes).Value;   % Names of measurement types as one string
    if ~ all(ismember(original_name(1:3),'(lp1'))                                   % Spezial case with only only 1 measurement type
        h5table.(original_name) = h5_data.(Attributes{k}(1:end-5));
    else
        names_1 = strsplit(original_name,newline)';                                 % temp name 1
        names_main = names_1(2:2:end-1);                                            % Final names of the measurement types
        for k_2 = 1:numel(names_main)
            if k_2 == 1
                names_main{k_2}([1:2,end]) = [];                                        % Special case for 1. measurement type names
                h5table.(names_main{k_2})  = h5_data.(Attributes{k}(1:end-5))(k_2,:)';
            else
                names_main{k_2}([1:3,end]) = [];
                h5table.(names_main{k_2})  = h5_data.(Attributes{k}(1:end-5))(k_2,:)';
            end
        end
    end
end

% Add datetime (Timestamp) to table
Timestep_GMT      = datetime(h5table.datetime64*10^-9,'ConvertFrom','epochtime','TimeZone','GMT');
h5table.Timestamp = datetime(Timestep_GMT,'TimeZone','Europe/Berlin','Format','dd.MM.yyyy HH:mm:ss');

% Old:
% h5table.Timestamp = ...                                                     
%     datetime(...
%     strrep  (...
%     cellstr (...
%     [num2str(h5table.YYYYMMDD),num2str(h5table.hhmmss)])...
%     ,' ','0'),...
%     'InputFormat' ,'yyyyMMddHHmmss',...
%     'Format','dd.MM.yyyy HH:mm:ss'...
%     );

h5table = h5table(:,[end 1:end-1]); % Timestamp first position