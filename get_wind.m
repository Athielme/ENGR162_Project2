function wind_vector = get_wind(lat, lon)
global wind_lat;
global wind_lon;
global wind_u;
global wind_v;

wind_vector = [interp2(wind_lat, wind_lon,wind_u,lat,lon) interp2(wind_lat, wind_lon, wind_v,lat,lon)];