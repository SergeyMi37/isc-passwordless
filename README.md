
[![OEX-zapm](https://img.shields.io/badge/dynamic/json?url=https:%2F%2Fpm.community.intersystems.com%2Fpackages%2Fpasswordless%2F&label=ZPM-pm.community.intersystems.com&query=$.version&color=green&prefix=passwordless)](https://pm.community.intersystems.com/packages/passwordless)

[![Docker-ports](https://img.shields.io/badge/dynamic/yaml?color=blue&label=docker-compose&prefix=ports%20-%20&query=%24.services.iris.ports&url=https%3A%2F%2Fraw.githubusercontent.com%2Fsergeymi37%2Fisc-passwordless%2Fmaster%2Fdocker-compose.yml)](https://raw.githubusercontent.com/sergeymi37/isc-passwordless/master/docker-compose.yml)

![](https://github.com/SergeyMi37/isc-passwordless/blob/master/doc/passless.png)

## passwordless

[![Online Demo](https://img.shields.io/badge/Demo%20on-GCR-black)](https://passwordless.demo.community.intersystems.com/csp/sys/UtilHome.csp)
[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fzapm&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fisc-passwordless)

Passwordless mode for IRIS developer mode through delegation discussed in the [article](https://github.com/SergeyMi37/isc-passwordless).
By default, passwordless mode is enabled for all applications with the `superuser` account. For customization, you can use environment variables. To do this, you need to copy file `.env_example` to file `.env` and edit the account and password.

## What's new

Added a method to rollback the delegated authorization method for modified web applications
```
do ##class(dc.passwordless).RestoreAutheApps("*")
```

## Installation with ZPM

If the current ZPM instance is not installed, then in one line you can install the latest version of ZPM even with a proxy.
```
s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="pm.community.intersystems.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")"
```
Or install native from repo latest betta version
```
s r=##class(%Net.HttpRequest).%New(),proxy=$System.Util.GetEnviron("https_proxy") Do ##class(%Net.URLParser).Parse(proxy,.pr) s:$G(pr("host"))'="" r.ProxyHTTPS=1,r.ProxyTunnel=1,r.ProxyPort=pr("port"),r.ProxyServer=pr("host") s:$G(pr("username"))'=""&&($G(pr("password"))'="") r.ProxyAuthorization="Basic "_$system.Encryption.Base64Encode(pr("username")_":"_pr("password")) set r.Server="github.com",r.SSLConfiguration="ISC.FeatureTracker.SSL.Config" d r.Get("/intersystems-community/zpm/releases/download/v0.4.1-beta.9/zpm-0.4.1-beta.9.xml"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
```

If ZPM is installed, then ZAPM can be set with the command
```
zpm:USER>install passwordless
```
or install native fpom repo with latest version
```
zpm:USER>install https://github.com/SergeyMi37/isc-passwordless
```

## Installation with Docker

### Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/isc-passwordless
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

Run the IRIS container with your project:

```
$ docker-compose up -d
```
If you need to make a passwordless login to another application, then you need to specify it in the parameter.

## How to Test it
Open IRIS terminal:
```
do ##class(dc.passwordless).Apply("/csp/sys","_system","SYS")
```


