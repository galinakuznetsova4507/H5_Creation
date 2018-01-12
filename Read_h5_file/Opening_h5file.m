filename = 'DB23_5min.h5';
info = h5info(filename);
% level2 = info.Groups(2);
A = h5read('DB23_5min.h5',[info.Groups(2).Name,'/',info.Groups(2).Datasets(1).Name]);
plot(A)
 