function h_under = submerged(berg_size)
density_ice = 920; %kg/m^3
density_water =  1000; %kg/m^3
h_under = (density_ice/density_water)*berg_size(3);
end