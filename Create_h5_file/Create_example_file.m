%% Setup

FileName     = 'Example_FileFor_h5';
num_instance = 1000;
rng(0);

%% File creation

Database = struct;
Database_fields = {'Table_1','Table_2','Table_3','Table_4','Table_5'};
Voltage_example = 230 +  5 *     randn(num_instance,1) ;
Current_example =  10 + 60 * abs(randn(num_instance,1));
for k_T = 1 : numel(Database_fields)    % k_Table
    rng(k_T)
    Database.(Database_fields{k_T}) = table;
    Database.(Database_fields{k_T}).U = ...
        Voltage_example(randperm(num_instance));
    Database.(Database_fields{k_T}).I = ...
        Current_example(randperm(num_instance));
end

%% Saving

save(FileName,'Database')