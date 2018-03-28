function M_v = temp_melting(T_w, del_t)
M_v = 7.62 * 10^-3 * T_w + 1.29 * 10^-3 * T_w^2; % meters per day
M_v = M_v * (1/24) * (1/60) * (1/60) * (1/del_t); % convert to meters per del_t
end