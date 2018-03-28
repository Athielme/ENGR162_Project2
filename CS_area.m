function area = CS_area(icebergDim,forceVector)
%CS_area Used to find the cross sectional area perpendicular to the
%forceVector input
%   icebergDim is a vector [length, width, height]
%   force vector is a vector [x, y, 0]

if norm(forceVector) ~= 0
    
    if length(forceVector) == 2
        forceVector(3) = 0;
    end
    
    if forceVector(2) < 0
        forceVector = forceVector .* -1;
    end
    
    len = icebergDim(1);
    width = icebergDim(2);
    height = icebergDim(3);

    if forceVector(2) > 0
        theta = atan(forceVector(1) / forceVector(2));
    else
        theta = 0;
    end
    
    cross_section_line = width*cos(theta) + len*sin(theta);

    area = abs(cross_section_line * height);
else
    area = 1;
end
end

