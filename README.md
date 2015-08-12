dco-vivo
========

[![Build Status](https://travis-ci.org/tetherless-world/dco-vivo.svg)](https://travis-ci.org/tetherless-world/dco-vivo)

Deep Carbon Observatory VIVO

Getting the source
```
% git clone https://github.com/tetherless-world/dco-vivo/
% cd dco-vivo
% git checkout <branch_name>
% git branch
% git submodule init
% git submodule update
```

Building vivo
* ant clean - does what you think it would do
* ant compile - builds the source. Does not build .war or run tests
* ant test - builds and runs the tests
* ant all - builds, runs tests, builds war file, copies the files to tomcat
** in build.properties change tomcat.home
* ant distribute - builds, runs tests, builds war files under .build/distribution/vivo.war

Testing DOI input
Try to find a DOI with limited authors who are in the DCO system already
* login to VIVO
* go to your profile in VIVO
* select the Publications tab
* click on the + next to "selected publications"
* Enter the DOI 10.1016/j.cageo.2007.12.019
* Click "Or import metadata from DOI"
* Make sure all the information is correct in the form. For authors and
journal please make sure to select one that already exists. We do not
want duplication from a test
* Click "Submit"
If all goes well you should see the new publication in the system. Now
delete it.


