//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Box
{
    %Docstring "deindented"
        A rectangular shape, to be used as a bin or to be placed in the scene.
    %End

    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Box(Point center);
    %Docstring "deindented"
        Create a 0x0 box at the specified position.

        It's intended that you adjust the size later.
        :param center: The coordinates of the center of the box.
    %End

    Box(Point min, Point max);
    %Docstring "deindented"
        Create a box that spans between two points.

        The ``max`` parameter MUST have greater X and Y coordinates than the
        ``min`` parameter. If this is not the case, the box will get a negative
        width or height and madness will ensue.

        The width and height of the box will automatically be determined from
        the difference between these two points. The centre will be the average
        of the two points.
        :param min: The minimum coordinates of the box.
        :param max: The maximum coordinates of the box.
    %End

    Box(long width, long height);
    %Docstring "deindented"
        Create a box with the specified dimensions.

        The box will be centered on the 0,0 coordinate.
        :param width: The width of the box.
        :param height: The height of the box.
    %End

    Box(long width, long height, Point center);
    %Docstring "deindented"
        Create a box with the specified dimensions, centered in a specified
        location.
        :param width: The width of the box.
        :param height: The height of the box.
        :param center: The coordinates of the center of the box.
    %End

    static Box infinite(Point center);
    %Docstring "deindented"
    Create a box with theoretically infinite dimensions.

    This is useful as a bin to place items in without necessarily bounding the
    placement of these items at any limit.

    The center of the box will be used if items are aligned by the placer to the
    center of the bin.
    :param center: The theoretical center of the box (to be treated as if it's
    just a very big box rather than mathematically infinite).
    :return: A box with theoretically infinite dimensions.
    %End

    Point minCorner();
    %Docstring "deindented"
        Returns the minimum coordinates that are still within the box.
        :return: The minimum coordinates of the box.
    %End

    Point maxCorner();
    %Docstring "deindented"
        Returns the maximum coordinates that are still within the box.
        :return: The maximum coordinates of the box.
    %End

    long width();
    %Docstring "deindented"
        Returns the width of the box, its span in the X direction.
        :return: The width of the box.
    %End

    long height();
    %Docstring "deindented"
        Returns the height of the box, its span in the Y direction.
        :return: The height of the box.
    %End

    long area();
    %Docstring "deindented"
        Returns the surface area of the box, i.e. the width times the height of
        the box.
        :return: The surface area of the box.
    %End

    Point center();
    %Docstring "deindented"
        Returns the center of the box, exactly in between the ``minCorner()``
        and the ``maxCorner()``.
        :return: The center of the box.
    %End
};