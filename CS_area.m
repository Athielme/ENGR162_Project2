function area = CS_area(icebergDim,forceVector)
%CS_area Used to find the cross sectional area perpendicular to the
%forceVector input
%   icebergDim is a vector [length, width, height]
%   force vector is a vector [x, y, 0]

if forceVector(2) < 0
    forceVector .* -1;
end

length = icebergDim(1);
width = icebergDim(2);
height = icebergDim(3);

theta = atan(forceVector(1) / (forceVector(2)));
cross_section_line = width*cos(theta) + length*sin(theta);

area = abs(cross_section_line * height);
end

