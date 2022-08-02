//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Point
{
    %Docstring
        Represents a point in 2D space or a 2D vector.
    %End
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Point(long x, long y);
    %Docstring
        Construct a new point with the given coordinates.
        :param x: The X coordinate of the new point.
        :param y: The Y coordinate of the new point.
    %End

    long x();
    %Docstring
        Return the X coordinate of the point.
        :return: The X coordinate of the point.
    %End
    %MethodCode
        sipRes = sipCpp->X; //Use Clipper implementation.
    %End

    long y();
    %Docstring
        Return the Y coordinate of the point.
        :return: The Y coordinate of the point.
    %End
    %MethodCode
        sipRes = sipCpp->Y; //Use Clipper implementation.
    %End
};