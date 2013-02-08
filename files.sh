rm -f jboss-native-2.0.*
rm -rf bin
rm -rf src/main/resources
for file in `cat files.list`
do
  HTTPFILE=`echo $file | sed 's:-1.0.0-:-2.0.12-:'`
  FILE=${HTTPFILE}
  CHANGETOSL=false
  # http://hudson.qa.jboss.com/hudson/view/Native/job/JBossWebNative-solaris-x64/lastSuccessfulBuild/artifact/jbossnative/build/unix/output/jboss-native-2.0.10-dev-solaris-x86-ssl.tar.gz
  case $FILE in
     \#*)
        echo $FILE skipped
        continue
        ;;
     *hpux-parisc2*)
        BASE=JBossWebNative-hp-ux-9000_800
        PLATFORM=hpux
        CPU=parisc2
        ;;
     *hpux64-parisc2*)
        BASE=JBossWebNative-hp-ux-9000_800_64
        PLATFORM=hpux
        CPU=parisc2W
        ;;
     *hpux-i64*)
        BASE=JBossWebNative-hp-ux-ia64
        PLATFORM=hpux
        CPU=i64
        CHANGETOSL=true
        ;;
     *linux2-x86*)
        BASE=JBossWebNative-linux-i686
        PLATFORM=linux2
        CPU=x86
        ;;
     *linux2-i64*)
        BASE=JBossWebNative-linux-ia64
        PLATFORM=linux2
        CPU=ia64
        ;;
     *linux2-x64*)
        BASE=JBossWebNative-linux-x86_64
        PLATFORM=linux2
        CPU=x64
        ;;
     *solaris-sun4v*)
        BASE=JBossWebNative-solaris10-sparc
        FILE=`echo ${HTTPFILE} | sed 's:-solaris-sun4v-:-solaris10-sparc-:'`
        HTTPFILE=`echo ${HTTPFILE} | sed 's:-solaris-sun4v-:-solaris10-sun4v-:'`
        PLATFORM=solaris10
        CPU=sparc
        ;;
     *solaris64-sun4v*)
        BASE=JBossWebNative-solaris10-sparc64
        FILE=`echo ${HTTPFILE} | sed 's:-solaris64-sun4v-:-solaris10-sparc64-:'`
        HTTPFILE=`echo ${HTTPFILE} | sed 's:-solaris64-sun4v-:-solaris10-sun4v-:'`
        PLATFORM=solaris10
        CPU=sparcv9
        ;;
     *solaris-sparcv9*)
        BASE=JBossWebNative-solaris9-sparc
        FILE=`echo ${HTTPFILE} | sed 's:-solaris-sparcv9-:-solaris9-sparc-:'`
        HTTPFILE=`echo ${HTTPFILE} | sed 's:-solaris-sparcv9-:-solaris9-sparcv9-:'`
        PLATFORM=solaris9
        CPU=sparc
        ;;
     *solaris64-sparcv9*)
        BASE=JBossWebNative-solaris9-sparc64
        FILE=`echo ${HTTPFILE} | sed 's:-solaris64-sparcv9-:-solaris-sparc64-:'`
        HTTPFILE=`echo ${HTTPFILE} | sed 's:-solaris64-sparcv9-:-solaris9-sparcv9-:'`
        PLATFORM=solaris9
        CPU=sparcv9
        ;;
     *solaris10-x86*)
        BASE=JBossWebNative-solaris10-x86
        PLATFORM=solaris10
        CPU=x86
        ;;
     *solaris10-x64*)
        BASE=JBossWebNative-solaris10-x64
        PLATFORM=solaris10
        CPU=x64
        ;;
     *solaris9-x86*)
        BASE=JBossWebNative-solaris9-x86
        PLATFORM=solaris9
        CPU=x86
        ;;
     *solaris9-x64*)
        BASE=JBossWebNative-solaris9-x64
        PLATFORM=solaris9
        CPU=x64
        ;;
     *macosx-x86*)
        BASE=JBossWebNative-macosx
        PLATFORM=macosx
        CPU=i386
        ;;
     *macosx-x64*)
        BASE=JBossWebNative-macosx-x64
        PLATFORM=macosx
        CPU=x64
        ;;
     *windows-amd64*)
        BASE=JBossWebNative-windows
        PLATFORM=windows
        CPU=x64
        ;;
     *windows-x86*)
        BASE=JBossWebNative-windows
        PLATFORM=windows
        CPU=x86
        ;;
  esac

  case $FILE in
      *.zip)
        TYPE=zip
        ;;
      *.tar.gz)
        TYPE=tar
        ;;
  esac
  export TYPE
  export CHANGETOSL

  mkdir -p src/main/resources/bin/META-INF/lib/${PLATFORM}
  echo $FILE
  echo $HTTPFILE
  echo $BASE
  echo "wget http://hudson.qa.jboss.com/hudson/view/Native/job/${BASE}/lastSuccessfulBuild/artifact/jbossnative/build/unix/output/$HTTPFILE"
  wget -q http://hudson.qa.jboss.com/hudson/view/Native/job/${BASE}/lastSuccessfulBuild/artifact/jbossnative/build/unix/output/$HTTPFILE || exit 1
  if [ $HTTPFILE != $FILE ]; then
    mv $HTTPFILE $FILE
  fi
  (cd src/main/resources/bin/META-INF/lib
   if [ $TYPE = "tar" ]; then 
     gzip -dc ../../../../../../$FILE | tar xf -
   else
     unzip -o ../../../../../../$FILE
   fi
   mv bin/native ${PLATFORM}/${CPU}
   if $CHANGETOSL; then
     (cd ${PLATFORM}/${CPU}
      for file in *.so
      do
        newfile=`echo $file | sed "s:.so:.sl:"`
        #echo "mv $file $newfile"
        mv $file $newfile 
      done
     )
   fi
   rm -rf bin
  ) || exit 1
done
