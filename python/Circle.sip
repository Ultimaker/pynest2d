//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Circle
{
    %Docstring
        A circular shape, to be used as bin or to be placed in the scene.
    %End

    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Circle();
    %Docstring
        Construct a circle centered at 0,0 with radius 0.
    %End

    Circle(Point center, double r);
    %Docstring
        Construct a circle centered at a specified location and with a specified
        radius.
        :param center: The position of the center of the circle.
        :param r: The radius of the new circle.
    %End

    Point center();
    %Docstring
        Gives the center position of the circle.
        :return: The center of the circle.
    %End

    void center(Point center);
    %Docstring
        Changes the center position of the circle.
        :param center: The new center of the circle.
    %End

    double radius();
    %Docstring
        Gives the radius of the circle.
        :return: The radius of the circle.
    %End

    void radius(double r);
    %Docstring
        Changes the radius of the circle.
        :param r: The new radius for the circle.
    %End

    double area();
    %Docstring
        Computes the area of the circle.

        The area is only a function of the radius: pi * r ** 2.
        :return: The area of the circle.
    %End
};