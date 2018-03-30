function vector_list = calc_path(lat, lon, t_end, del_t)
ct_lat = -18.4241;
ct_lon = 33.9249;

lon_degree_length = 96490; % meters
lat_degree_length = 110600; % meters

dir_vector = [ct_lon - lon, ct_lat - lat];
dir_vector = [dir_vector(1)*lon_degree_length, dir_vector(2)*lat_degree_length, 0]; % convert to meters

counter = 1;
for i = [0:del_t:t_end]
    vector_list_x(counter) = dir_vector(1);
    vector_list_y(counter) = dir_vector(2);
    counter = counter + 1;
end

vector_list = [vector_list_x; vector_list_y];
vector_list = transpose(vector_list);

end