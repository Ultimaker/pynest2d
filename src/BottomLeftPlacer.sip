//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class BottomLeftPlacer
{
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
    %End

public:
    class PackResult
    {
    private:
        PackResult(double overfit);
        PackResult(Item item);
    public:
        double overfit();
    };

    BottomLeftPlacer(Box box);
    void configure(BottomLeftConfig config);

    void bin(Box box);
    Box bin();

    PackResult trypack(Item item);
    bool pack(Item item);
    Item leftPoly(Item item);
    Item downPoly(Item item);
    long availableSpaceLeft(Item item);
    long availableSpaceDown(Item item);
    void clearItems();
    void accept(PackResult r);
    void unpackLast();
    double filledArea();
};