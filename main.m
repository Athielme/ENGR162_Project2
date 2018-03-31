clc;
t_start = 0;
t_end = 1000;
del_t = 10;
times = [t_start:del_t:t_end];

%% Berg position setup
berg_v = [0,0];
berg_x = 0;
berg_y = 0;

berg_lat_start = -67.775;
berg_lon_start = 21.868;

berg_lat(1) = berg_lat_start;
berg_lon(1) = berg_lon_start;

berg_size = [200,200,70];
berg_mass = berg_size(1)*berg_size(2)*berg_size(3)*1000;

%% Air setup
air_lat = ncread('wind_data.nc','lat');
air_lon = ncread('wind_data.nc','lon');

air_u = ncread('wind_data.nc','u');
air_u = air_u(1:length(air_lon),1:length(air_lat));
air_u(isnan(air_u)) = 4;

air_v = ncread('wind_data.nc','v');
air_v = air_v(1:length(air_lon),1:length(air_lat));
air_v(isnan(air_v)) = 4;

air_velocity(1,:) = get_wind(air_lat, air_lon, air_u, air_v, berg_lat_start, berg_lon_start);

%% Water Setup
water_lat = ncread('water_data.nc4', 'latitude');
water_lon = ncread('water_data.nc4', 'longitude');
water_u = ncread('water_data.nc4', 'u');
water_v = ncread('water_data.nc4', 'v');
water_velocity(1,:) = get_current(water_lat, water_lon, water_u, water_v, berg_lat_start, berg_lon_start);
%%

direction(1,:) = calc_path(berg_lat_start, berg_lon_start);

%% Main Calculation Loop
disp("Starting main loop...")
% norm_berg = 0:length(times);
% berg_x = zeros(length(times) + 1);
% berg_y = zeros(length(times) + 1);
% berg_lat = zeros(length(times) + 1);
% berg_lon = zeros(length(times) + 1);
counter = 1;
for t = times
    direction(counter + 1,:) = calc_path(berg_lat, berg_lon);
    
    water_velocity(counter + 1,:) = get_current(water_lat, water_lon, water_u, water_v, berg_lat(counter), berg_lon(counter));
    air_velocity(counter + 1,:) = get_wind(air_lat, air_lon, air_u, air_v, berg_lat(counter), berg_lon(counter));
    
    air_force = F_air(air_velocity(counter,:),berg_v(counter,:), berg_size);
    water_force = F_water(water_velocity(counter,:), berg_v(counter,:), berg_size);
    boat_force = F_boat(direction(counter,:), air_force + water_force);
    berg_force = air_force + water_force + boat_force;
    
    berg_v(counter + 1,:) = berg_v(counter, :) + (del_t/berg_mass).*( ...
          berg_force);
    
    norm_berg(counter) = norm(berg_v(counter,:));
    berg_x(counter + 1) = berg_x(counter) + berg_v(counter + 1, 1) * del_t;
    berg_y(counter + 1) = berg_y(counter) + berg_v(counter + 1, 2) * del_t;
    
    berg_lat(counter + 1) = berg_lat_start + meter_to_lat(berg_y(counter));
    berg_lon(counter + 1) = berg_lon_start + meter_to_lon(berg_x(counter));
    
    
    if mod(t,10) == 0
        disp(t)
    end
    counter = counter + 1;
end

% %% FREE BODY DIAGRAM
% figure(1)
% quiver([0,0,0],[0,0,0], [air_force(1),water_force(1), berg_force(1)], [air_force(2),water_force(2), berg_force(2)])
% title("Free Body Diagram of Iceberg")
% xlabel("Force (N)")
% ylabel("Force (N)")
% xlim([-20 20])
% ylim([-20 20])
% 
% %% ICEBERG POSITION (Small Scale)
% figure(2)
% scatter(berg_x,berg_y)
% title("Position of Iceberg (Small Scale)")
% xlabel("X Position (m)")
% ylabel("Y Position (m)")

%% ICEBERG POSITION (Large Scale)
figure(3)
scatter(berg_lon,berg_lat)

title("Position of Iceberg (Large Scale)")
xlabel("X Position (km)")
ylabel("Y Position (km)")

% %% Tugboat Force 
% figure(4)
% plot(times, norm_berg)
% 
% title("Tugboat Force Required to Maintain Desired Course")
% xlabel("Time (hours)");
% ylabel("Force Required (N)");
% 
% %% Mass loss
% figure(5)
% plot(times, [10000:-100:0])
% 
% title("Iceberg Mass Loss")
% xlabel("Time (hours)")
% ylabel("Icberg Mass (kg)")
% 
% %% Voyage cost
% figure(6)
% plot(times, norm_berg .* 10000)
% 
% title("Cost of Voyage")
% xlabel("Time (hours)");
% ylabel("Cost ($)");