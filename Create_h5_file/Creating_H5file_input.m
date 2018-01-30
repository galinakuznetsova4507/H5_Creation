%   The script is intended to converting a database to H5 format
%   (hierarchical, filesystem-like data format). 
%   *Maybe create a function of this script
%   Authors: Robert Brandalik 
%            Galina Kuznetsova

%% Clear start
clear; 
clc

%% Setup
Input__filename = 'Example_FileFor_h5';
Output_filename = 'Example_File.h5';

%% Read in Input File
data     = load(Input__filename);                                           % loading mat-file
Database = data.(cell2mat(fields(data)));                                   % call the loaded file 'Database'

%% 
Create_H5file(Output_filename, Database);
                                                          