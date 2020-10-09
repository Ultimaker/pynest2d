//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Item
{
    %Docstring
        An item represents something that needs to be fit in the scene.

        An item has a certain shape. For these Python bindings that shape will
        always be a polygon.

        After the nesting has taken place, the item will be transformed. The
        transformation is encoded in a translation and a rotation. You may also
        manually scale the item if necessary. The transformed shape can be
        computed with the transformedShape() function. The original vertex
        coordinates are not modified then. The item will also be placed in a
        certain bin, which is normally the first bin unless the first bin is
        packed completely full.

        An item can be fixed in place with the markAsFixedInBin() function,
        preventing the nester to move it. It only blocks other items
        from being placed then.
    %End

    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Item(PyObject* vertex_list);
    %Docstring
        Create a new item from a list of vertices.

        Each vertex must be a Point instance.
        :param vertex_list: A list of Points that form the vertices of the
        polygonal shape of this item.
    %End
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
    %Docstring
        The bin that this item is assigned to, or -1 if it's not (yet) assigned
        to any bin.

        The assigned bin is a version of the bin shape. If all objects fit in
        one bin, their bin IDs will all be 0. If they don't fit, new bins will
        be created and some objects will be put in the new bin.
        :return: The currently assigned bin of this item.
    %End

    void binId(int idx);
    %Docstring
        Assign this item to a bin.

        Assigning to a negative number effectively takes this object out of all
        bins. Use -1 to unassign the item from all bins.
        :param idx: The index of the bin to assign the item to.
    %End

    bool isFixed();
    %Docstring
        Whether this item is fixed in place, not able to be moved by the nester.

        If the item is fixed, the nester is not allowed to move it and must
        place other items around it.
        :return: Whether the item is fixed in a certain bin.
    %End

    bool isDisallowedArea();
    %Docstring
        Whether this item is a disallowed area, not able to be moved by the
        nester and not grouped together with other items.

        If the item is a disallowed area, the nester is not allowed to move it
        and not allowed to place other items in the same spot. Contrary to
        simple fixed items, other items will not be packed nearby disallowed
        areas by the optimization.
        :return Whether the item is a disallowed area.
    %End

    void markAsFixedInBin(int binid);
    %Docstring
        Make this item a fixed item in a certain bin.

        If the item is fixed, the nester is not allowed to move it and must
        place other items around it in that bin.

        This currently only works with the FirstFit selector (which is the
        default).
        :param binid: The bin in which this item is fixed.
    %End

    void markAsDisallowedAreaInBin(int binid);
    %Docstring
        Make this item a disallowed area in a certain bin.

        If the item is a disallowed area, the nester is not allowed to move it
        and not allowed to place other items in the same spot. Contrary to
        simple fixed items, other items will not be packed nearby disallowed
        areas by the optimization.

        This currently only works with the FirstFit selector (which is the
        default).
        :param binid: The bin in which this item is a disallowed area.
    %End

    int priority();
    %Docstring
        Gives the current priority of selecting this item.

        Items with greater priority (higher number) get selected first by the
        selectors.
        :return: The priority of selecting this item.
    %End

    void priority(int priority);
    %Docstring
        Sets the priority of selecting this item.

        Items with greater priority (higher number) get selected first by the
        selectors. This causes them to be placed in earlier bins and perhaps
        more towards the point where the objects get aligned to (depending on
        the placer).

        The priority is not a guarantee. The selector may still select different
        items first. It only serves as an intuitive way to steer which objects
        are the most important to be placed.
        :param priority: The priority to give to this item.
    %End

    std::string toString();
    %Docstring
        Give a string representation of this item.
            
        This will give a list of all the vertices in the contour of the item.
        :return: A string representation of the item.
    %End

    Point vertex(long idx);
    %Docstring
        Get a vertex from the contour of the item.
        :param idx: The index of the vertex. Should not be vertexCount() or
        higher.
        :return: A point along the contour of the item.
    %End

    void setVertex(long idx, Point v);
    %Docstring
        Change a vertex on the contour of the item.
        :param idx: The index of the vertex to change. Should not be
        vertexCount() or higher.
        :param v: The new coordinates of that vertex.
    %End

    double area();
    %Docstring
        Compute the surface area of the item.

        This is a signed area. If the polygon has the wrong winding order, this
        area will be negative.
        :return: The surface area of the item.
    %End

    bool isContourConvex();
    %Docstring
        Compute whether the shape of this item is completely convex.

        The result is cached, so it is safe to query convexity multiple times on
        the same item as long as the item is not modified in between.
        :return: True if the item is convex, or False otherwise.
    %End

    bool isHoleConvex(long holeindex);
    %Docstring
        For holes in the shape, return if the hole is convex.
        :param holeindex: The index of the hole in the shape. Should be less
        than holeCount().
        :return: True if the specified hole is convex, or False if it's concave.
    %End

    bool areHolesConvex();
    %Docstring
        Returns whether all holes are convex.

        This is the same as going through all holes and querying isHoleConvex()
        for all of them.
        :return: True if all holes in the shape are convex, or False if there is
        at least one concave hole.
    %End

    long vertexCount();
    %Docstring
        Get the number of vertices in total in the shape of the item.
        :return: The number of vertices in the contour.
    %End

    long holeCount();
    %Docstring
        Get the number of holes in the shape of the item.
        :return: The number of holes in the shape.
    %End

    bool isInside(Point p);
    %Docstring
        Tests whether a point is contained in the shape of this item.
        :param p: The point to test whether it's contained in this item.
        :return: True if the point is inside the shape, or False if it's
        outside.
    %End

    bool isInside(Item sh);
    %Docstring
        Tests whether a different item is engulfed wholly inside of this item.
        :param sh: The item to test for whether it is inside of this item.
        :return: True if the item is wholly engulfed in this item, or False if
        it falls partially or completely outside of this item.
    %End

    bool isInside(Box box);
    %Docstring
        Tests whether the box falls completely inside of this item.
        :param box: The box to test for being contained in this item.
        :return: True if the box is wholly engulfed in this item, or False if it falls partially or completely outside of this item.
    %End

    bool isInside(Circle circle);
    %Docstring
        Tests whether the circle falls completely inside of this item.
        :param circle: The circle to test for being contained in this item.
        :return: True if the circle is wholly engulfed in this item, or False if it falls partially or completely outside of this item.
    %End

    Box boundingBox();
    %Docstring
        Return the smallest axis-aligned bounding box around this item.
        :return: A bounding box around this item.
    %End

    Point referenceVertex();
    %Docstring
        Return a vertex that serves as a reference for this item's shape.

        The vertex will always be the same if the vertices of the item are the
        same, even if those vertices are in a different order or if a different
        item has precisely the same vertices. This can be used for instance to
        always start iteration in the same spot if the shape is the same.
        :return: A vertex that serves as reference for the shape.
    %End

    Point rightmostTopVertex();
    %Docstring
        Returns the right-most vertex (highest X coordinate). Or if multiple
        vertices are equally far right, the top-most one of those (highest Y
        coordinate).

        This works on the transformed shape.
        :return: The highest of the right-most vertices.
    %End

    Point leftmostBottomVertex();
    %Docstring
        Returns the left-most vertex (lowest X coordinate). Or if multiple
        vertices are equally far left, the bottom-most one of those (lowest Y
        coordinate).

        This works on the transformed shape.
        :return: The lowest of the left-most vertices.
    %End

    void translate(Point delta);
    %Docstring
        Move the item relatively in a certain direction.

        The vertices are not actually transformed in-place, but the
        transformation of the item is changed. The moved vertices can be found
        by calling transformedShape().

        To arrive at the transformed shape of an item, the rotation is applied
        first, then the translation. Translation is only afterwards, so first
        translating the object and then rotating it will not cause the item to
        rotate by the translation vector around 0. It will rotate around its
        original 0 coordinate instead.
        :param delta: The motion vector by which to move this item.
    %End

    Point translation();
    %Docstring
        Get the current translation of the item.

        This gets changed by arranging the items in the bins.
        :return: The current translation of the item.
    %End

    void rotate(double radians);
    %Docstring
        Rotate the item by a certain amount.

        The vertices are not actually transformed in-place, but the
        transformation of the item is changed. The moved vertices can be found
        by calling transformedShape().
        :param radians: The amount of rotation to apply, in radians. A positive
        rotation will rotate the item counter-clockwise.
    %End

    double rotation();
    %Docstring
        Get the current amount of rotation applied to the model.

        This gets changed by arranging the items in the bins.
        :return: The current rotation of the model.
    %End

    void inflation(long distance);
    %Docstring
        Offset the shape by a certain amount. This will make the shape wider in
        all directions, as if performing a Minkowski sum with a circle with the
        specified distance as radius.

        A negative distance will result in an inset of the original shape.
        :param distance: The distance by which to offset the shape.
    %End

    long inflation();
    %Docstring
        Get the current amount of inflation from the original shape.
        :return The current amount of inflation.
    %End

    Item transformedShape();
    %Docstring
        Create a new item that has the transformation of this item applied to
        its vertices.

        From the new item you can get the vertex coordinates to get the
        polygonal coordinates of the transformed shape.
        :return: A copy of this item, but with the transformation applied to its
        vertices.
    %End

    void resetTransformation();
    %Docstring
        Remove all transformations on this item, reverting it to its original
        state.
    %End

    static bool intersects(Item sh1, Item sh2);
    %Docstring
        Test whether two items intersect.

        Two items intersect only if they have a non-zero area of overlap.
        :param sh1: One of the items to test intersection with.
        :param sh2: The other item to test intersection with.
        :return: True if they intersect, or False if they are disjoint.
    %End

    static bool touches(Item sh1, Item sh2);
    %Docstring
        Test whether two items touch.

        Touching items includes the edge case where two items touch only on a vertex or on an edge but don't necessarily have any positive area of overlap. They may also just touch on the contour of the shape.

        If two items intersect, they also always touch.
    %End
};