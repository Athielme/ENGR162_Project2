function dir_vector = calc_path(lat, lon)
ct_lat = -18.4241;
ct_lon = 33.9249;

lon_degree_length = 96490; % meters
lat_degree_length = 110600; % meters

dir_vector = [ct_lon - lon, ct_lat - lat];
dir_vector = [dir_vector(1)*lon_degree_length, dir_vector(2)*lat_degree_length]; % convert to meters

end