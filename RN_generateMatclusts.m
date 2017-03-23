exit_status=true;
throw_errors=true;

if ~exist('RN_createAllMatclustFiles.m','file')
	error('RN_createAllMatclustFiles.m not in path!!! ... exiting');
end

%% Process all .SPIKES folders in directory to generate matlab files

spikefiles = subdir('*.spikes');
curr_dir = pwd;

fprintf('Found %d potential spike folders! ...\n',...
    numel(spikefiles));
for d = 1:numel(spikefiles)
    if spikefiles(d).isdir
        
        try
        
        fprintf('About to process %s matclust files ...\n',...
            spikefiles(d).name);
		[where_to_proces, ~] = fileparts(spikefiles(d).name);
		cd(where_to_proces);
		
% 		Processes the matclust files into the same .spikes folder
         RN_createAllMatclustFiles(mjc);
        
        catch ME
           processError(ME,'Matclust');
           if throw_errors
               rethrow(ME);
           end
        end

    end
end
cd(curr_dir);

%% Fix wave paths in param files
disp('Fixing wave path in param files...')
matclustDir = subdir('*.matclust');
if numel(matclustDir)==1,
    fixParamPaths(matclustDir.name);
end
disp('Done Done Done!!!')
%% Terminate

% Compute exit status
if ~exist('ME','var') || isempty(ME)
    exit_status = 0;
else
    exit_status = 0;
end

% if ~exit_status
%     exit;
% end