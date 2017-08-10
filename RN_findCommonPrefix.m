function [commonStr] = RN_findCommonPrefix(C)
% findCommonPrefix finds the common prefix among a cell array of strings
if numel(C)==1
    commonStr = C{1};
    return;
end
A = C{1};
C = C(2:end);
N = 0;
CMP = ones(size(C));
while all(CMP)
    N=N+1;
    CMP = strncmp(A,C,N);
end
N=N-1;
if N==0
    commonStr = '';
    return;
end
commonStr = A(1:N);

if strcmp(commonStr(end),'_')
    commonStr = commonStr(1:end-1);
end

if commonStr(end) == '.'
    commonStr = commonStr(1:end-1);
end
