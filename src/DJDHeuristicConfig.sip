//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct DJDHeuristicConfig
{
    %TypeHeaderCode
        #include <libnest2d/libnest2d.hpp>
        using DJDHeuristicConfig = DJDHeuristic::Config; //Make an alias since SIP doesn't deal with namespaces.
    %End

    bool try_reverse_order;
    bool try_pairs;
    bool try_triplets;
    double initial_fill_proportion;
    double waste_increment;
    double allow_parallel;
    bool force_parallel;
};