nDays = numel(day_dirs);

%% Rec Order Query and write
% Query for rec order for each day_dir
RecOrder = cell(1,nDays);
for i=1:nDays,
  recFiles = dir([day_dirs{i} filesep '*.rec']);
  [~,idx] = sort({recFiles.date});
  recFiles = {recFiles(idx).name}';
  RecOrder{i} = RN_ListGUI(recFiles,'Set Rec Order:');
end

% Write rec order code string
RecOrderCode = ['RecOrder = ' getCellStrCode(RecOrder)];
