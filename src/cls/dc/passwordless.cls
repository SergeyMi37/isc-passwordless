/// Passwordless mode for Dev Mode IRIS
Class dc.passwordless
{

/// write ##class(dc.passwordless).Apply("/csp/sys")
ClassMethod Apply(app = "") {
	quit:app="" $$$OK
	new $namespace
 	set $namespace="%SYS"

	set:app="" app= $System.Util.GetEnviron("ISC_app")
	set:app="" app="/csp/sys"
	
	;set par("AutheEnabled")=32    ; Password
	set par("AutheEnabled")=8256  ; Unauthenticated + Delegated
	;set par("AutheEnabled")=8192  ; Delegated
	;set par("AutheEnabled")=64 ; Unauthenticated
	;set par("AutheEnabled")=8224 ; Password, Delegated
	
	set tSC=##class(Security.Applications).Modify(app,.par)
	if 'tSC quit tSC
	
	set role="%All"
	set tSC=##class(Security.Users).AddRoles("UnknownUser",.role,1)    

	quit tSC
    }
}

