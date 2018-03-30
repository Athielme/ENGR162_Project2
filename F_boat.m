function F_b = F_boat(desired_force, other_forces)
max_boat_force = 10; % Newtons
force_dif = desired_force - other_forces;

if(norm(force_dif) > max_boat_force)
    force_dif = force_dif./norm(force_dif); % convert to unit vector
    F_b = force_dif .* max_boat_force;
else
    F_b = force_dif;
end
end