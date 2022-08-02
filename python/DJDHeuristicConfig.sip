//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

struct DJDHeuristicConfig
{
    %Docstring
        This structure contains configuration options for the DJD Heuristic of
        selecting objects to place.

        The following options are available:
        * try_reverse_order (default True):
        If true, the algorithm will try to place pairs and triplets in all
        possible orders. It will have a hugely negative impact on performance.
        * try_pairs (default True):
        Whether to try pairs of items to pack. It will add a quadratic component
        to the complexity.
        * try_triplets (default False):
        Whether to try groups of 3 items to pack. This could be very slow for
        large numbers of items (>100) as it adds a cubic component to the complexity.
        * initial_fill_proportion (default 1/3):
        The initial fill proportion of the bin area that will be filled before
        trying items one by one, or pairs or triplets.
        The initial fill proportion suggested by Lopez-Camacho is one third of
        the area of the bin.
        * waste_increment (default 0.1):
        How much is the acceptable waste incremented at each iteration.
        * allow_parallel (default True):
        Allow parallel jobs for filling multiple bins. This will decrease the
        solution quality but can greatly boost up performance for large numbers
        of items.
        * force_parallel (default False):
        Always use parallel processing if the items don't fit into one bin.
    %End

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