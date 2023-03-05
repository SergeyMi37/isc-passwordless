/// Passwordless mode for Dev Mode IRIS
Class dc.passwordless
{

/// write ##class(dc.passwordless).Apply()
ClassMethod Apply(app = "")
{
 	new $namespace
 	set $namespace="%SYS"

	set:app="" app= $System.Util.GetEnviron("ISC_app")
	set:app="" app="/csp/sys"
	
	;par("AutheEnabled")=8256  ;не + уполно
	;par("AutheEnabled")=8192 ;упол
	;set par("AutheEnabled")=64 ;не
	set par("AutheEnabled")=8224 ;пароль + уполном
	set tSC=##class(Security.Applications).Modify(app,.par)
	if 'tSC quit tSC
	
	;set role="%All"
	;set tSC=##class(Security.Users).AddRoles("UnknownUser",.role,1)    

	quit tSC
}

