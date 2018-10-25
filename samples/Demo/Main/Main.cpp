#include <atlbase.h>
#include "Greeter_i.h"
#include "Greeter_i.c"

int main(int argc, char** argv)
{
    CoInitialize(NULL);
    {
        CComPtr<IGreeter> gr;
        gr.CoCreateInstance(CLSID_Greeter);
        gr->greet();
    }
    CoUninitialize();
    
    return 0;
}