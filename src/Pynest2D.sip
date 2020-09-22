//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

%Module(name = pynest2d, call_super_init = True)

%Include BottomLeftConfig.sip
%Include BottomLeftPlacer.sip
%Include Box.sip
%Include Circle.sip
%Include Item.sip
%Include Point.sip
%Include Rectangle.sip
%Include String.sip

%ModuleHeaderCode
namespace libnest2d{
    namespace placers{}
}
using namespace libnest2d;
using namespace placers;
%End

