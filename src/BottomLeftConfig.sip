//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct BottomLeftConfig
{
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
        using BottomLeftConfig = BLConfig<ClipperLib::Path>; //Specialise the templated BLConfig class since SIP doesn't deal with templates.
    %End

    long min_obj_distance;
    long epsilon;
    bool allow_rotations;
};