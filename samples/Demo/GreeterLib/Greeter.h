#pragma once
#include "resource.h" 
#include "Greeter_i.h"

class ATL_NO_VTABLE CGreeter :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CGreeter, &CLSID_Greeter>,
	public IDispatchImpl<IGreeter, &IID_IGreeter, &LIBID_GreeterLib, /*wMajor =*/ 1, /*wMinor =*/ 0>
{
public:
	DECLARE_REGISTRY_RESOURCEID(IDR_GREETER)

	BEGIN_COM_MAP(CGreeter)
		COM_INTERFACE_ENTRY(IGreeter)
		COM_INTERFACE_ENTRY(IDispatch)
	END_COM_MAP()

	DECLARE_PROTECT_FINAL_CONSTRUCT()

public:
	STDMETHOD(greet)();
};

OBJECT_ENTRY_AUTO(__uuidof(Greeter), CGreeter)