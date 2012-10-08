eSalsa Deploy web interface
===========================

A jersey rest webservice on a embedded jetty webserver with an ExtJS user interface.

Requirements
------------

### Jars

* Jersey
    <pre>
    cd lib
    wget 'http://maven.java.net/service/local/artifact/maven/redirect?r=releases&g=com.sun.jersey&a=jersey-archive&v=1.14&e=zip'
    unzip  jersey-archive-1.14.zip
    </pre>
* Jetty
    <pre>
    cd lib
    JETTY_VERSION=7.0.2.v20100331
    wget -U none http://repo1.maven.org/maven2/org/eclipse/jetty/aggregate/jetty-all/$JETTY_VERSION/jetty-all-$JETTY_VERSION.jar
    wget -U none http://repo1.maven.org/maven2/javax/servlet/servlet-api/2.5/servlet-api-2.5.jar
    </pre>

### ExtJS

Download ExtJS on http://www.sencha.com and extract in webapp/ directory.

Usage
-----

Launch nl.nlesc.esalsa.deploy.ws.EmbeddedServer.main the open browser at http://localhost:8085 .

Compile js
----------

Out of the box all required ExtJS classes are loaded seperate.
To concat and compress into one js file first install SenchaCmd then run

    cd webapp
    sencha -s ext-4.1.1a compile -classpath ext-4.1.1a/src,app page -yui -in index.html -out index.build.html
    gzip -c all-classes.js all-classes.js.gz

