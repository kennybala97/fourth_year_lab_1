function [mean_peak_distance,peak_distance_std] = get_peak_statistics(cal_data)
[pks,locs] = findpeaks(cal_data.amplitude);

locs_inds = find(pks > 60);

peak_positions = cal_data.distance(locs(locs_inds));
peak_distances = diff(peak_positions);
mean_peak_distance = mean(peak_distances);
peak_distance_std = std(peak_distances);
end

