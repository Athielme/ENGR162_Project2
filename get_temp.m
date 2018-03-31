function temp = get_temp(temps_lat, temps_lon, temps, lat, lon)

temp = interp2(temps_lat, temps_lon, temps', lat, lon);
end