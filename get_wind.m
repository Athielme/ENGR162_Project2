function wind_vector = get_wind(wind_lat, wind_lon, wind_u, wind_v, lat, lon)

wind_vector = [interp2(wind_lat, wind_lon,wind_u,lat,lon,'linear',4) interp2(wind_lat, wind_lon, wind_v,lat,lon,'linear',4)];