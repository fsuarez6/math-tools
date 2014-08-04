function [filenames] = get_files_by_pattern(path, extension, pattern)
  files = dir(fullfile(path, extension));
  names = {files(:).name}';
  found = 1;
  for i = 1:length(names)
    if not(isempty(strfind(names{i}, pattern)))
      filenames{found} = names{i};
      found = found + 1;
    end
  end
end
