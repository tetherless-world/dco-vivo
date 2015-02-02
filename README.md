dco-vivo
========

Deep Carbon Observatory VIVO

Building vivo
* ant clean - does what you think it would do
* ant compile - builds the source. Does not build .war or run tests
* ant test - builds and runs the tests
* ant all - builds, runs tests, builds war file, copies the files to tomcat
** in build.properties change tomcat.home
* ant distribute - builds, runs tests, builds war files under .build/distribution/vivo.war
