//Copyright (c) 2022 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

%Module(name = pynest2d, call_super_init = True)

%Include BottomLeftConfig.sip
%Include Box.sip
%Include Circle.sip
%Include DJDHeuristicConfig.sip
%Include Item.sip
%Include ItemGroup.sip
%Include NfpConfig.sip
%Include Point.sip
%Include Rectangle.sip
%Include String.sip

%ModuleHeaderCode
#include <libnest2d/backends/clipper/geometries.hpp>
#include <libnest2d/optimizers/nlopt/subplex.hpp> //Use the Subplex local optimizer. Also imported by libnest2d.hpp but somehow this needs to be imported in correct order!
#include <libnest2d/libnest2d.hpp>
namespace libnest2d{
    namespace placers{}
}
using namespace libnest2d;
using namespace placers;
%End

/*!
 * Convert ranges of Item objects to and from Python lists.
 */
%MappedType std::vector<Item*>
{
    %TypeHeaderCode
        #include <utility>
        #include <vector>
        using ItemRange = std::pair<std::vector<Item>::iterator, std::vector<Item>::iterator>;
    %End

    %ConvertFromTypeCode //From std::vector<Item> to Python list.
        const long size = sipCpp->size();
        if(size < 0)
        {
            return NULL;
        }
        PyObject* result_list = PyList_New(size);
        if(!result_list)
        {
            return NULL;
        }
        for(size_t i = 0; i < size; ++i)
        {
            Item* item = sipCpp->at(0);
            PyObject* python_item = sipConvertFromType(item, sipType_Item, sipTransferObj);
            if(!python_item)
            {
                Py_DECREF(result_list);
                return NULL;
            }
            PyList_SET_ITEM(result_list, i, python_item);
        }
        return result_list;
    %End

    %ConvertToTypeCode //From Python list to vector of Items.
        PyObject* iterator = PyObject_GetIter(sipPy);
        if(!sipIsErr) //We're only checking if it can be converted.
        {
            //Must be any iterable.
            const bool iterable = (iterator != NULL);
            Py_XDECREF(iterator);
            return iterable;
        }

        std::vector<Item*>* storage_vector = new std::vector<Item*>();
        PyObject* list_item;
        while(list_item = PyIter_Next(iterator))
        {
            if(!sipCanConvertToType(list_item, sipType_Item, SIP_NOT_NONE))
            {
                PyErr_Format(PyExc_TypeError, "Object in iterable cannot be converted to a libnest2d Item.");
                *sipIsErr = 1;
                break;
            }
            int state;
            Item* item = reinterpret_cast<Item*>(sipConvertToType(list_item, sipType_Item, 0, SIP_NOT_NONE, &state, sipIsErr));
            if(!*sipIsErr)
            {
                storage_vector->push_back(item);
            }

            sipReleaseType(item, sipType_Item, state);
            Py_DECREF(list_item);
        }

        Py_DECREF(iterator);
        if(*sipIsErr)
        {
            delete storage_vector;
            return 0;
        }
        *sipCppPtr = storage_vector;
        return sipGetState(sipTransferObj);
    %End
};

long nest(std::vector<Item*> items, Box bin, long distance = 1, NfpConfig config = NfpConfig());
%Docstring
    Arrange a number of items in bins, packing them closely with the goal to
    minimise the number of bins necessary to pack all given items.

    This function uses the FirstFit selector and NfpPPlacer in its algorithms,
    and Clipper as geometry back-end.

    The result of the packing is stored in the transformation of the input
    items. You can get the transformed items by calling transformedShape() on
    each of the items, or by looking at their rotation and translation. Items
    may also be placed on alternative bins if the first bin is not big enough to
    fit all items.
    :param items: An iterable of Item instances which are the items that need to
    be placed in the bins.
    :param bin: The shape in which to place these items.
    :param distance: (Default 1.) The distance to hold between adjacent items in
    the final pack result. Items will not get placed closer than this distance.
    Must be at least 1 unit.
    :param config: An NfpConfig instance that contains configuration options to
    specialize how objects get placed. Defaults will be used if this is not
    provided.
    :return: The number of bins necessary to fit all items.
%End
%MethodCode
    //Pre-process distance.
    if(a2 <= 0)
    {
        a2 = 1; //Need to keep at least 1 unit of distance, or the nester breaks.
    }

    //Pre-process items.
    std::vector<Item> to_arrange;
    to_arrange.reserve(a0->size());
    for(Item* item : *a0)
    {
        to_arrange.push_back(*item);
    }

    //Pre-process config.
    NestConfig<> nest_config(*a3); //NestConfig wraps a placer and selector config. Only with the default selector there is no config, so just the placer then.

    sipRes = nest(to_arrange, *a1, a2, nest_config);

    for(size_t i = 0; i < a0->size(); ++i)
    {
        *(a0->at(i)) = to_arrange[i];
    }
%End
