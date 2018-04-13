function dayDirs = getDayDirectories(inDir)

    if inDir(end)==filesep
        inDir = inDir(1:end-1);
    end
    if ~isempty(dir([inDir filesep '*.rec']))
        dayDirs = inDir;
        return;
    end
    
    dayDirs = {};
    a = dir(inDir);
    for i=1:numel(a),
        if a(i).name(1)=='.' || ~a(i).isdir
            continue;
        else
            dayDirs = [dayDirs;getDayDirectories([inDir filesep a(i).name])];
        end
    end
