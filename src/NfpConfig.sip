//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct NfpConfig
{
    %Docstring
        This is a configuration structure to configure the NfpPPlacer. It has
        several attributes to configure how it places items.

        The following options are available:
        * alignment (default CENTER):
        Where to align the resulting packed pile.
        * starting_point (default CENTER):
        Where to start placing items in the bin.
        * rotations (default [0, 0.5 * pi, pi, 1.5 * pi]):
        Rotations to try to place the object in. More rotations may cause the objects to be packed closer together, but also significantly increases computation time.
        * accuracy (default 0.65):
        How far to search for the best placement. 0.0 is not very accurate, but computes fast. 1.0 is the best accuracy, but takes a lot of computation power.
        * explore_holes (default False):
        Whether to allow placing items inside holes in other shapes. This functionality doesn't currently work in libnest2d.
        * parallel (default True):
        Whether to try different options in multiple threads in parallel.
    %End
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
        using NfpConfig = NfpPConfig<ClipperLib::Polygon>; //Specialise the templated NfpPConfig class since SIP doesn't deal with templates.
    %End

    enum class Alignment
    {
        CENTER,
        BOTTOM_LEFT,
        BOTTOM_RIGHT,
        TOP_LEFT,
        TOP_RIGHT,
        DONT_ALIGN
    };

    Alignment alignment;
    Alignment starting_point;

    std::vector<double> rotations
    {
        %GetCode
            sipPy = PyList_New(sipCpp->rotations.size());
            for(size_t i = 0; i < sipCpp->rotations.size(); ++i)
            {
                PyList_SET_ITEM(sipPy, i, PyFloat_FromDouble(sipCpp->rotations[i]));
            }
        %End

        %SetCode
            if(!PyList_Check(sipPy))
            {
                sipErr = 1;
                return 1;
            }
            sipCpp->rotations.clear();
            PyErr_Clear();
            size_t size = PyList_Size(sipPy);
            sipCpp->rotations.reserve(size);
            for(size_t i = 0; i < size; ++i)
            {
                sipCpp->rotations.push_back(PyFloat_AsDouble(PyList_GET_ITEM(sipPy, i)));
            }
            return 0;
        %End
    };

    double accuracy;
    bool explore_holes;
    bool parallel;
};