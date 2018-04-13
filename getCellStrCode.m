function [ codeStr ] = getCellStrCode( cellArr )
% getCellStrCode: Write a cell array of strings as matlab code
codeStr = '{';
for i=1:numel(cellArr),
    switch class(cellArr{i})
        case 'char'
            codeStr = [codeStr '''' cellArr{i} ''''];
        case 'cell'
            codeStr = [codeStr '{''' strjoin(cellArr{i},''',...\n''') '''}'];
        otherwise
            error('Each element of cellArr must be a string or cell array of strings');
    end
    if i~=numel(cellArr)
        codeStr = [codeStr ',...' char(10)];
    end
end
codeStr = [codeStr '};'];
end  % getCellStrCode
