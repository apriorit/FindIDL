#include <atlbase.h>
#include <iostream>
#include "Greeter_i.h" // generated from idl
#include "Greeter_i.c" // generated from idl

int main(int argc, char** argv)
{
    CoInitialize(nullptr);

    {
        CComPtr<IGreeter> greeter;
        if (FAILED(greeter.CoCreateInstance(CLSID_Greeter)))
        {
            std::cerr << "Failed to create CLSID_Greeter instance!" << std::endl;
            return -1;
        }

        greeter->greet();
    }

    CoUninitialize();
    
    return 0;
}