//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Circle
{
    %TypeHeaderCode
    #include <libnest2d/libnest2d.hpp>
    %End

public:
    Circle();
    Circle(Point center, double r);
    Point center();
    void center(Point center);
    double radius();
    void radius(double r);
    double area();
};