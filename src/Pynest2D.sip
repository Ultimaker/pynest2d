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
            PyObject* python_item = sipConvertFromInstance(item, sipClass_Item, sipTransferObj);
            if(!python_item)
            {
                Py_DECREF(result_list);
                return NULL;
            }
            PyList_SET_ITEM(result_list, i, python_item);
        }
        return result_list;
    %End

    %ConvertToTypeCode //From Python list to range of iterators.
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
            if(!sipCanConvertToInstance(list_item, sipClass_Item, SIP_NOT_NONE))
            {
                PyErr_Format(PyExc_TypeError, "Object in iterable cannot be converted to a libnest2d Item.");
                *sipIsErr = 1;
                break;
            }
            int state;
            Item* item = reinterpret_cast<Item*>(sipConvertToInstance(list_item, sipClass_Item, 0, SIP_NOT_NONE, &state, sipIsErr));
            if(!*sipIsErr)
            {
                storage_vector->push_back(item);
            }

            sipReleaseInstance(item, sipClass_Item, state);
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

long nest(std::vector<Item*> items, Box bin);
%MethodCode
    std::vector<Item> to_arrange;
    to_arrange.reserve(a0->size());
    for(Item* item : *a0)
    {
        to_arrange.push_back(*item);
    }

    sipRes = nest(to_arrange.begin(), to_arrange.end(), *a1, 1, {});

    for(size_t i = 0; i < a0->size(); ++i)
    {
        *(a0->at(i)) = to_arrange[i];
    }
%End

long nest(std::vector<Item*> items, Box bin, long distance);
%MethodCode
    if(a2 <= 0)
    {
        a2 = 1; //Need to keep at least 1 unit of distance, or the nester breaks.
    }

    std::vector<Item> to_arrange;
    to_arrange.reserve(a0->size());
    for(Item* item : *a0)
    {
        to_arrange.push_back(*item);
    }

    sipRes = nest(to_arrange.begin(), to_arrange.end(), *a1, a2, {});

    for(size_t i = 0; i < a0->size(); ++i)
    {
        *(a0->at(i)) = to_arrange[i];
    }
%End
