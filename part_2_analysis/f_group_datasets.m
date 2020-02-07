function [group_id, grouped_data] = f_group_datasets(grouping_var,to_split, rounding)
[G, group_id] = findgroups(round(grouping_var,rounding));
grouped_data = splitapply(@sum, to_split, G);
end

