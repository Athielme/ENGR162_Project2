function current_vector = get_current(water_lat, water_lon, water_u, water_v, lat, lon)

current_vector = [interp2(water_lat, water_lon,water_u,lat,lon) interp2(water_lat, water_lon, water_v,lat,lon)];