function [folder_list] = get_folder_list(path, extension, pattern)
  complete_list = dir(path);
  % Select only the folders
  is_folder = [complete_list(:).isdir]; 
  folder_list = {complete_list(is_folder).name}'; % '
  % Remove the current and previous folders
  folder_list(ismember(folder_list,{'.','..'})) = [];
end
