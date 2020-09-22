//Copyright (c) 2020 Ultimaker B.V.
//pynest2d is released under the terms of the LGPLv3 or higher.

/*!
 * Mapping std::string to Python str objects.
 *
 * Based on implementation of libSavitar.
 */
%MappedType std::string
{
    %TypeHeaderCode
        #include <string>
    %End

    %ConvertFromTypeCode
        PyObject* result = PyUnicode_DecodeUTF8(sipCpp->c_str(), sipCpp->length(), NULL);
        if(!result)
        {
            result = PyBytes_FromString(sipCpp->c_str());
        }
        return result;
    %End

    %ConvertToTypeCode
        if(!sipIsErr) //Just a request to check if we can convert.
        {
            return PyBytes_Check(sipPy) || PyUnicode_Check(sipPy); //We can convert from Python bytes and str.
        }

        if(sipPy == Py_None) //Convert None to empty string. Happens when we supply no parameter to the str() function.
        {
            *sipCppPtr = new std::string();
            return 1;
        }
        else if(PyUnicode_Check(sipPy)) //Is a str.
        {
            PyObject* str = PyUnicode_AsEncodedString(sipPy, "UTF-8", ""); //Temporarily convert to Python str which has the AS_STRING function.
            *sipCppPtr = new std::string(PyBytes_AS_STRING(str));
            Py_DECREF(str); //Temporary object goes immediately out of scope.
            return 1;
        }
        else if(PyBytes_Check(sipPy)) //Is a str.
        {
            *sipCppPtr = new std::string(PyBytes_AS_STRING(sipPy));
            return 1;
        }
        else
        {
            return 0;
        }
    %End
};