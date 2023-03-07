/// Passwordless mode for Dev Mode IRIS
Class dc.passwordless
{

/// write ##class(dc.passwordless).Apply("/csp/sys")
ClassMethod Apply(app = "/csp/sys")
{
	quit:app="" $$$OK
	new $namespace
 	set $namespace="%SYS"

	set:app="" app= $System.Util.GetEnviron("ISC_app")
	set:app="" app="/csp/sys"
	
	// Edit Security Authentication/Web Session Options
	set ss=##class(Security.System).%OpenId("SYSTEM")
	If '$ZBoolean(ss.AutheEnabled, $$$AutheDelegated, 1) {
		Set ss.AutheEnabled = ss.AutheEnabled + $$$AutheDelegated
	}
	set tSC=ss.%Save()
	
	set tSC=##class(Security.Applications).Get(app,.par)
	// Remove unauthenticated and add delegated
	If $ZBoolean(par("AutheEnabled"), $$$AutheUnauthenticated, 1) {
		Set par("AutheEnabled") = par("AutheEnabled") - $$$AutheUnauthenticated
	}
	If '$ZBoolean(par("AutheEnabled"), $$$AutheDelegated, 1) {
		Set par("AutheEnabled") = par("AutheEnabled") + $$$AutheDelegated
	}
	
	set tSC=##class(Security.Applications).Modify(app,.par)
	if 'tSC quit tSC
	
	quit tSC
}

}

