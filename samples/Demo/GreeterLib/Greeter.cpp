#include "stdafx.h"
#include "Greeter.h"

STDMETHODIMP CGreeter::greet()
{
    std::cout << "Greet! ";
    return S_OK;
}
