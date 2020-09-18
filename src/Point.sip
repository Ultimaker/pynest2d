//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Point
{
    %TypeHeaderCode
    #include <libnest2d/libnest2d.hpp>
    %End

public:
    Point(long x, long y);
    long X;
    long Y;
};

