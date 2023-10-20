/// Passwordless mode for Dev Mode IRIS
Class dc.passwordless
{

Parameter GN = "^%ZAPM.AppsDelegate";

/// write ##class(dc.passwordless).Apply("/csp/sys")
ClassMethod Apply(app = "/csp/sys", user = "", pass = "", mode = "0")
{
	quit:app="" $$$OK
	new $namespace
	if $namespace'="%SYS" {
		write !,""
		if $$EXIST^%R("ZAUTHENTICATE.mac","%SYS") {
			set msg="Routine ZAUTHENTICATE.mac in %SYS already installed"
			write !,msg
			if mode=1 quit $$$OK
			if mode=2 quit $$$ERROR($$$GeneralError,msg)
		}
		set tempFile = ##class(%File).TempFilename("xml")
		set list("ZAUTHENTICATE.MAC")=""
		set list("dc.passwordless.CLS")=""
		set st=$SYSTEM.OBJ.Export(.list, tempFile)
		set $namespace="%SYS"
		set st = $SYSTEM.OBJ.Load(tempFile, "c")
		if 'st {
			set msg=$System.Status.GetErrorText(st) write !,msg 
			quit $$$ERROR($$$GeneralError,msg)
		}
	}
 	set $namespace="%SYS"

	set:app="" app= $System.Util.GetEnviron("ISC_app")
	set:app="" app="/csp/sys"
	
	// Edit Security Authentication/Web Session Options
	set ss=##class(Security.System).%OpenId("SYSTEM")
	If '$ZBoolean(ss.AutheEnabled, $$$AutheDelegated, 1) {
		Set ss.AutheEnabled = ss.AutheEnabled + $$$AutheDelegated
	}
	set st=ss.%Save()
	if 'st quit st
	
	if app="*" {
		set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
		set tSC=result.Prepare("select Name FROM Security.Applications")
		set:tSC tSC=result.Execute()
		if '$$$ISOK(tSC) {
			set text="Application setup error :"_$SYSTEM.Status.GetErrorText(tSC)  
			write !,text 
			QUIT $$$ERROR(text)
		}
		else {
			while result.Next() {
				set CSP=result.Data("Name")
				set csp=$zconvert(CSP,"L")
				set st=..AddDelegate(csp,user,pass)
			}
		write !,"OK"
		}	
	}
	elseif app["," {
		set a=""
		for i=1:1:$l(app,",") { set a=$p(app,",",i)
			continue:a=""
			set st=..AddDelegate(a,$p(user,",",i),$p(pass,",",i))
		}
	}
	else {
		set st=..AddDelegate(app,user,pass)
	}
	quit $$$OK
}

/// write ##class(dc.passwordless).RestoreAutheApps("*")
ClassMethod RestoreAutheApps(app = "")
{
 new $namespace
 set $namespace="%SYS"
	if app="*" {
		set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
		set tSC=result.Prepare("select Name FROM Security.Applications")
		set:tSC tSC=result.Execute()
		if '$$$ISOK(tSC) {
			set text="Application setup error :"_$SYSTEM.Status.GetErrorText(tSC)  
			write !,text 
			QUIT $$$ERROR(text)
		}
		else {
			while result.Next() {
				set CSP=result.Data("Name")
				set csp=$zconvert(CSP,"L")
				set st=..RestoreApp(csp)
			}
		write !,"OK"
		}	
	}
}

ClassMethod RestoreApp(app)
{
	if '$d(@..#GN@("Authe",app)) write !,app," skip" quit $$$OK
	set st=##class(Security.Applications).Get(app,.par)
	if st {
		kill par
		merge par=@..#GN@("Authe",app)
		set st=##class(Security.Applications).Modify(app,.par)
		write !,app," restore"
	}
	Quit st
}

ClassMethod AddDelegate(app, user = "", pass = "")
{
	set st=##class(Security.Applications).Get(app,.par)
	if st {
		//Save for restore
		if '$d(@..#GN@("Authe",app)) merge @..#GN@("Authe",app)=par
		
		//Skip Unauthenticated only
		if par("AutheEnabled")=$$$AutheUnauthenticated quit $$$OK
		
		// Remove unauthenticated and add delegated
		If $ZBoolean(par("AutheEnabled"), $$$AutheUnauthenticated, 1) {
			Set par("AutheEnabled") = par("AutheEnabled") - $$$AutheUnauthenticated
		}
		If '$ZBoolean(par("AutheEnabled"), $$$AutheDelegated, 1) {
			Set par("AutheEnabled") = par("AutheEnabled") + $$$AutheDelegated
		}
		
		set st=##class(Security.Applications).Modify(app,.par)
		if st {
			set acc=""
			if user'="" set acc=$lb(user,pass)
			if $e(app,*)'="/" set app=app_"/"
			set @..#GN@(app)=acc
		}
	}
	Quit st
}

}

