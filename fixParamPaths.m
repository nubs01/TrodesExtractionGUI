function h = fixParamPaths(matclustDir)
h=0;
cd(matclustDir)
paramFiles = dir('param*.mat');
for i=1:numel(paramFiles),
    filedata = load(paramFiles(i).name);
    filedata = filedata.filedata;
    nFile = paramFiles(i).name;
    nFile = ['waves' nFile(6:end)];
    filedata.filename = nFile;
    save(paramFiles(i).name,'filedata');
end
h=1;