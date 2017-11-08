#! /usr/bin/env bash
set -xe

export BASEDIR=$(dirname "$0")
export NAME="elastalert"
export VERSION="0.1.18"
export REVISION="1.el7"

find $BUILDDIR ! -perm -a+r -exec chmod a+r {} \;

cd $BUILDDIR$INSTALLDIR/elastalert
 virtualenv-tools --update-path $INSTALLDIR/elastalert
cd -

# Clean up
find $BUILDDIR -iname *.pyc -exec rm {} \;
find $BUILDDIR -iname *.pyo -exec rm {} \;


fpm -f \
    --iteration $REVISION \
    -t rpm -s dir -C $BUILDDIR -n $NAME -v $VERSION \
    --config-files "/etc/elastalert/config.yml" \
    --config-files "/etc/sysconfig/elastalert" \
    --config-files "/usr/lib/systemd/system/elastalert.service" \
    --before-install $BASEDIR/scripts/preinstall.sh \
    --after-install $BASEDIR/scripts/postinstall.sh \
    --after-remove $BASEDIR/scripts/postuninstall.sh \
    --url http://elastalert.readthedocs.io/en/latest \
    --maintainer 'devops@qualys.com' \
    --description 'ElastAlert - Easy & Flexible Alerting With Elasticsearch.' \
    --license 'Apache 2.0' \
    --package $BASEDIR \
    .
