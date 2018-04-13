function processError(ME, codeSection)
    disp('Error occured while running...');

    savestr = ['''' datestr(now,'mm.dd-HH:MM-') ...
        codeSection '_BashTrodes_Matlab_ProcessingError.mat' ''''];

    line = {ME.stack.line}; name= {ME.stack.name};
    for section = 1:numel(line)
        fprintf('\n------------------\n');
        for section = 1:numel(line)
        fprintf('Line %d: %s\n', ...
            line{section}, name{section});
        end
        fprintf('Workspace saved in %s', savestr);
        fprintf('\n------------------\n');
    end

    evalstr = ['save(' savestr ');'];
    evalin('caller',evalstr);
end
