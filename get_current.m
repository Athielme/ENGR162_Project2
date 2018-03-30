function current_vector = get_current(lat, lon)
global water_lat;
global water_lon;
global water_u;
global water_v;

current_vector = [interp2(water_lat, water_lon,water_u,lat,lon) interp2(water_lat, water_lon, water_v,lat,lon)];