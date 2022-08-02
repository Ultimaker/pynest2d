//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class Rectangle
{
    %Docstring
        A rectangular item. This item can be placed in the bins and arranged
        there. Some algorithms may work faster on rectangles than on arbitrary
        polygons.
    %End
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    Rectangle(long width, long height);
    %Docstring
        Construct a new rectangle with a specified width and height. The
        bottom-left corner of the rectangle will be placed at the 0-coordinate.
        :param width: The width of the new rectangle.
        :param height: The height of the new rectangle.
    %End

    long width();
    %Docstring
        Get the width of this rectangle.
        :return: The width of the rectangle.
    %End

    long height();
    %Docstring
        Get the height of this rectangle.
        :return: The height of the rectangle.
    %End

    //Members inherited from Item.
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

    void markAsFixedInBin(int binid);
    %Docstring
        Make this item a fixed item in a certain bin.

        If the item is fixed, the nester is not allowed to move it and must
        place other items around it in that bin.

        This currently only works with the FirstFit selector (which is the
        default).
        :param binid: The bin in which this item is fixed.
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