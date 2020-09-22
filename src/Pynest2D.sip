//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

%Module(name = pynest2d, call_super_init = True)

%Include BottomLeftConfig.sip
%Include BottomLeftPlacer.sip
%Include Box.sip
%Include Circle.sip
%Include Item.sip
%Include NfpConfig.sip
%Include NfpPlacer.sip
%Include Point.sip
%Include Rectangle.sip
%Include String.sip

%ModuleHeaderCode
#include <libnest2d/optimizers/nlopt/subplex.hpp> //Use the Subplex local optimizer. Also imported by libnest2d.hpp but somehow this needs to be imported in correct order!
#include <libnest2d/libnest2d.hpp>
namespace libnest2d{
    namespace placers{}
}
using namespace libnest2d;
using namespace placers;
%End

long nest(PyObject* item_list, Box bin);
%MethodCode
    if(!PyList_Check(a0))
    {
        return NULL;
    }
    std::vector<Item> items;
    const size_t size = PyList_GET_SIZE(a0);
    items.reserve(size);
    PyErr_Clear(); //To allow us to test if any Python errors occurred.

    for(size_t i = 0; i < size; ++i)
    {
        PyObject* list_item = PyList_GET_ITEM(a0, i);
        if(!sipCanConvertToType(list_item, sipType_Item, SIP_NOT_NONE))
        {
            return NULL;
        }
        int iserr = 0;
        Item* item = reinterpret_cast<Item*>(sipConvertToType(list_item, sipType_Item, 0, SIP_NOT_NONE, NULL, &iserr));
        if(!item || iserr)
        {
            return NULL;
        }
        items.push_back(*item);
        if(PyErr_Occurred() != NULL) //Something broke. Need to clean up. Maybe the input is not proper Point instances.
        {
            return NULL;
        }
    }
    sipRes = nest(items.begin(), items.end(), *a1);
%End
