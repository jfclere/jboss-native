jboss-native
============

build the jboss-native jar using hudson builds.

buid the multi platform jar for AS7
to build:
build.sh
to make a new release:
edit ./files.sh
change HTTPFILE=`echo $file | sed 's:-1.0.0-:-2.0.10-:'`
For exampel 2.0.11 :D
