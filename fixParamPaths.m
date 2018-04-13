function h = fixParamPaths(matclustDir)
h=0;
cd(matclustDir)
paramFiles = dir('param*.mat');
for i=1:numel(paramFiles),
    filedata = load(paramFiles(i).name);
    filedata = filedata.filedata;
    nFile = paramFiles(i).name;
    nFile = strrep(nFile,'param','waves');
    fprintf('Changing Param File Path from %s to %s\n',filedata.filename,nFile)
    filedata.filename = nFile;
    save(paramFiles(i).name,'filedata');
end
h=1;
