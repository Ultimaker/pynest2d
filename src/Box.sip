//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Box
{
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Box(Point center);
    Box(Point min, Point max);
    Box(long width, long height);
    Box(long width, long height, Point center);
    static Box infinite(Point center);
    Point minCorner();
    Point maxCorner();
    long width();
    long height();
    long area();
    Point center();
};