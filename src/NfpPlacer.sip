//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

class NfpPlacer
{
    %TypeHeaderCode
        #include <libnest2d/optimizers/nlopt/subplex.hpp> //Use the Subplex local optimizer. Also imported by libnest2d.hpp but somehow this needs to be imported in correct order!
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

    NfpPlacer(Box bin);
    NfpPlacer(NfpPlacer&);
    void configure(NfpConfig config);

    Box bin();
    void bin(Box bin);

    static double overfit(Box bb, Item bin);
    static double overfit(Item chull, Item bin);
    static double overfit(Box bb, Box bin);
    static double overfit(Item chull, Box bin);
    static double overfit(Box bb, Circle bin);
    static double overfit(Item chull, Circle bin);
    PackResult trypack(Item);
    bool pack(Item);
    void clearItems();
};