clc;
clear;
t_start = 0;
del_t = 600;
times(1) = t_start;

%% Berg position setup
berg_v = [0,0];
berg_x = 0;
berg_y = 0;

berg_lat_start = -67.775;
berg_lon_start = 21.868;

berg_lat(1) = berg_lat_start;
berg_lon(1) = berg_lon_start;

direction(1,:) = calc_path(berg_lat_start, berg_lon_start);

berg_size = [200,200,70];
berg_mass(1) = berg_size(1)*berg_size(2)*berg_size(3)*1000;

%% Air/wind setup
air_lat = ncread('wind_data.nc','lat');
air_lon = ncread('wind_data.nc','lon');

air_u = ncread('wind_data.nc','u');
air_u = air_u(1:length(air_lon),1:length(air_lat));
air_u(isnan(air_u)) = 4;

air_v = ncread('wind_data.nc','v');
air_v = air_v(1:length(air_lon),1:length(air_lat));
air_v(isnan(air_v)) = 4; %% Replace missing values with average value of 4 m/s

air_velocity(1,:) = get_wind(air_lat, air_lon, air_u, air_v, berg_lat_start, berg_lon_start);

%% Air temperature setup
temp_data = importdata('Modified Water Temp Data.csv');

temp_lat = temp_data(2:end, 1);
temp_lon = temp_data(1, 2:end);

temps = temp_data(2:end,2:end);
temps(find(temps == 99999)) = 0; % replace missing values with 0
water_temp(1) = get_temp(temp_lat, temp_lon, temps, berg_lat_start, berg_lon_start);

%% Water Setup
water_lat = ncread('water_data.nc4', 'latitude');
water_lon = ncread('water_data.nc4', 'longitude');
water_u = ncread('water_data.nc4', 'u');
water_v = ncread('water_data.nc4', 'v');
water_velocity(1,:) = get_current(water_lat, water_lon, water_u, water_v, berg_lat_start, berg_lon_start);

%% Main Calculation Loop
disp("Starting main loop...")
% norm_berg = 0:length(times);
% berg_x = zeros(length(times) + 1);
% berg_y = zeros(length(times) + 1);
% berg_lat = zeros(length(times) + 1);
% berg_lon = zeros(length(times) + 1);
counter = 1;
while abs(berg_lon(counter) - 33.9249) > .1
    t = times(counter);
    direction(counter + 1,:) = calc_path(berg_lat, berg_lon);
    
    water_velocity(counter + 1,:) = get_current(water_lat, water_lon, water_u, water_v, berg_lat(counter), berg_lon(counter));
    air_velocity(counter + 1,:) = get_wind(air_lat, air_lon, air_u, air_v, berg_lat(counter), berg_lon(counter));
    water_temp(counter + 1) = get_temp(temp_lat, temp_lon, temps, berg_lat(counter), berg_lon(counter));
    
    berg_size(1) = berg_size(1) - temp_melting(water_temp(counter), del_t);
    berg_mass(counter + 1) = berg_size(1)*berg_size(2)*berg_size(3)*1000;
    
    air_force = F_air(air_velocity(counter,:),berg_v(counter,:), berg_size);
    water_force = F_water(water_velocity(counter,:), berg_v(counter,:), berg_size);
    boat_force = F_boat(direction(counter,:), air_force + water_force);
    berg_force = air_force + water_force + boat_force;
    
    berg_v(counter + 1,:) = berg_v(counter, :) + (del_t/berg_mass(counter)).*( ...
          berg_force);
    
    norm_berg(counter) = norm(berg_v(counter,:));
    berg_x(counter + 1) = berg_x(counter) + berg_v(counter + 1, 1) * del_t;
    berg_y(counter + 1) = berg_y(counter) + berg_v(counter + 1, 2) * del_t;
    
    berg_lat(counter + 1) = berg_lat_start + meter_to_lat(berg_y(counter));
    berg_lon(counter + 1) = berg_lon_start + meter_to_lon(berg_x(counter));
    
    
    if mod(counter,25) == 0
        disp(t)
        disp(abs(berg_lon(counter) - 33.9249))
    end
    times(counter + 1) = times(counter) + del_t;
    counter = counter + 1;
end
figure(1)
%% ICEBERG POSITION (Large Scale)
subplot(1,3,1)
scatter(berg_lon,berg_lat)

title("Position of Iceberg (Large Scale)")
xlabel("X Position (km)")
ylabel("Y Position (km)")

%% Tugboat Force 
subplot(1,3,2)
plot(times(1:end-1)./3600, norm_berg)

title("Tugboat Force Required to Maintain Desired Course")
xlabel("Time (hours)");
ylabel("Force Required (N)");

%% Mass loss
subplot(1,3,3)
plot(times./3600, berg_mass)

title("Iceberg Mass Loss")
xlabel("Time (hours)")
ylabel("Icberg Mass (kg)")

% 
% %% Voyage cost
% figure(6)
% plot(times, norm_berg .* 10000)
% 
% title("Cost of Voyage")
% xlabel("Time (hours)");
% ylabel("Cost ($)");