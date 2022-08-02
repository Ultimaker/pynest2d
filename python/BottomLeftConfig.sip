//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct BottomLeftConfig
{
    %Docstring "deindented"
        Configuration class for the BLPlacer class.

        With this you can configure some parameters on how the BLPlacer places
        objects.

        The following attributes can be set:
        * min_obj_distance (default 0):
        Minimum distance between objects. This seems to not be used by libnest2d
        at the moment.
        * epsilon (default 1):
        Resolution of placement. The lower the epsilon, the more placements will
        be attempted, resulting in better placement but longer computation time.
        * allow_rotations (default False):
        Whether the placer is allowed to rotate the items. This placer will only
        attempt 90 degree rotations if this setting is set to True.
    %End
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
        using BottomLeftConfig = BLConfig<ClipperLib::Polygon>; //Specialise the templated BLConfig class since SIP doesn't deal with templates.
    %End

    long min_obj_distance;
    long epsilon;
    bool allow_rotations;
};