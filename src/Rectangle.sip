//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Rectangle
{
    %TypeHeaderCode
    #include <libnest2d/libnest2d.hpp>
    %End

public:
    Rectangle(long width, long height);
    long width();
    long height();

    //Members inherited from Item.
    int binId();
    void binId(int idx);
    int priority();
    void priority(int priority);
    std::string toString();

    double area();
    bool isContourConvex();
    bool isHoleConvex(long holeindex);
    bool areHolesConvex();
    long vertexCount();
    long holeCount();
    bool isInside(Point p);
    bool isInside(Item sh);
    bool isInside(Box box);
    bool isInside(Circle circle);
    Box boundingBox();
    Point referenceVertex();
    Point rightmostTopVertex();
    Point leftmostBottomVertex();

    void translate(Point delta);
    Point translation();
    void rotate(double radians);
    double rotation();
    void inflation(long distance);
    long inflation();
    Item transformedShape();
    void resetTransformation();

    static bool intersects(Item sh1, Item sh2);
    static bool touches(Item sh1, Item sh2);
};