
## passwordless

Passwordless mode for Dev Mode IRIS

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
