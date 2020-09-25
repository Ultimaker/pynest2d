//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Item
{
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Item(PyObject* vertex_list);
    %MethodCode
        if(!PyList_Check(a0))
        {
            return NULL;
        }
        std::vector<Point> vertices;
        const size_t size = PyList_GET_SIZE(a0);
        vertices.reserve(size);
        PyErr_Clear(); //To allow us to test if any Python errors occurred.
        for(size_t i = 0; i < size; ++i)
        {
            PyObject* vertex = PyList_GET_ITEM(a0, i);
            const long x = PyLong_AsLong(PyObject_CallMethod(vertex, "x", NULL));
            const long y = PyLong_AsLong(PyObject_CallMethod(vertex, "y", NULL));
            vertices.emplace_back(x, y);
            if(PyErr_Occurred() != NULL) //Something broke. Need to clean up. Maybe the input is not proper Point instances.
            {
                return NULL;
            }
        }
        sipCpp = new Item(vertices); //Makes a copy of the vertices!
    %End

    int binId();
    void binId(int idx);
    bool isFixed();
    void markAsFixedInBin(int binid);
    int priority();
    void priority(int priority);
    std::string toString();
    Point vertex(long idx);
    void setVertex(long idx, Point v);

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