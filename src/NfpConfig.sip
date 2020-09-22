//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct NfpConfig
{
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