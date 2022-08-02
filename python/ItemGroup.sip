//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

%MappedType ItemGroup
{
    %TypeHeaderCode
        #include <utility>
        #include <vector>
        using ItemGroup = PlacementStrategyLike<NfpPlacer>::ItemGroup; //Make an alias here since SIP doesn't namespace syntax nor template syntax.
    %End

    %ConvertFromTypeCode //From ItemGroup to Python list.
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
            Item item = sipCpp->at(0);
            PyObject* python_item = sipConvertFromType(&item, sipType_Item, sipTransferObj);
            if(!python_item)
            {
                Py_DECREF(result_list);
                return NULL;
            }
            PyList_SET_ITEM(result_list, i, python_item);
        }
        return result_list;
    %End

    %ConvertToTypeCode //From Python list to ItemGroup.
        PyObject* iterator = PyObject_GetIter(sipPy);
        if(!sipIsErr) //We're only checking if it can be converted.
        {
            //Must be any iterable.
            const bool iterable = (iterator != NULL);
            Py_XDECREF(iterator);
            return iterable;
        }

        ItemGroup* result = new ItemGroup();
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
                result->push_back(*item);
            }

            sipReleaseType(item, sipType_Item, state);
            Py_DECREF(list_item);
        }

        Py_DECREF(iterator);
        if(*sipIsErr)
        {
            delete result;
            return 0;
        }
        *sipCppPtr = result;
        return sipGetState(sipTransferObj);
    %End
};