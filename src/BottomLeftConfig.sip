//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct BottomLeftConfig
{
    %DocString
        Configuration class for the BLPlacer class.

        With this you can configure some parameters on how the BLPlacer places
        objects.
    %End
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
        using BottomLeftConfig = BLConfig<ClipperLib::Polygon>; //Specialise the templated BLConfig class since SIP doesn't deal with templates.
    %End

    long min_obj_distance;
    %DocString
        Minimum distance between objects.

        This seems to not be used by libnest2d at the moment.
    %End

    long epsilon;
    %DocString
        Resolution of placement.

        The lower the epsilon, the more placements will be attempted, resulting
        in better placement but longer computation time.
    %End

    bool allow_rotations;
    %DocString
        Whether the placer is allowed to rotate the items.

        This placer will only attempt 90 degree rotations if this setting is set
        to True.
    %End
};