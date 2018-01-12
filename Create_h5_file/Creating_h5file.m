 
%% Creating H5File (converting)
clear
clc
filename = 'DB23_5min_res_2016';
data = load(filename);                                                      % loading mat-file

Files = fields(data.DB23_5min);                                             % sub-files from mat-file
fid = H5F.create('DB23_5min.h5');                                           % creation of H5 file

%% Creating the H5G group with names of subfiles 
for i = 1:length(Files);
    group{i} = H5G.create(fid,[Files{i}],size(Files{i},1));                 % group of subfiles
    
    tablevalues = data.DB23_5min.(Files{i});                                % values of all columns of the subfile
    info = h5info('DB23_5min.h5');
  
%% Creating the H5D Dataset with values of the table
    for j = 2:size((tablevalues),2);
        heading{j}   = cell2mat(tablevalues.Properties.VariableNames(1,j)); % name of each column
        parameter{j} = tablevalues.(j);                                     % values of one column
        
        type_id = H5T.copy('H5T_NATIVE_DOUBLE');                           
        h5_dims = fliplr(size(parameter{j}));
        space_id = H5S.create_simple(2,h5_dims,h5_dims);                    % create a new data space
        dset{j} = H5D.create(group{i},heading{j},type_id,space_id,...       % create new Dataset for all values
            'H5P_DEFAULT');
        
        fileattrib('DB23_5min.h5','+w');
        H5D.write(dset{j},'H5ML_DEFAULT','H5S_ALL','H5S_ALL',...            % write a data to Dataset
            'H5P_DEFAULT',parameter{j});
        
    end
end

