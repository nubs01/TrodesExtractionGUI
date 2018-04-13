function out = RN_generateMatclusts(mjc)
	exit_status=true;
	throw_errors=true;

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

				% Processes the matclust files into the same .spikes folder
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
        pause(5)
	    fixParamPaths(matclustDir.name);
	end
	disp('Done Done Done!!!')
	%% Terminate
	out = matclustDir;
end
