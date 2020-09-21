//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

%Module(name = pynest2d, call_super_init = True)

%Include Box.sip
%Include Circle.sip
%Include Point.sip

%ModuleHeaderCode
namespace libnest2d{}
using namespace libnest2d;
%End

