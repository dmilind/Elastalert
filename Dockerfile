FROM centos:centos7
LABEL maintainer="Milind Dhoke"

ENV BUILDDIR="/tmp/build"
ENV INSTALLDIR="/usr/share/python" 
ARG Version

RUN mkdir -p ${BUILDDIR}/etc/elastalert/rules && \
    mkdir -p ${BUILDDIR}/etc/sysconfig/ && \
    mkdir -p $BUILDDIR/usr/lib/systemd/system

COPY conf/config.yml ${BUILDDIR}/etc/elastalert/
COPY conf/elastalert.sysconfig ${BUILDDIR}/etc/sysconfig/elastalert
COPY conf/elastalert.service ${BUILDDIR}/usr/lib/systemd/system 

RUN yum -y update && yum clean all
RUN yum -y install ruby ruby-devel gcc make rpm-build openssl-devel libffi-devel epel-release && \
    yum -y install python-pip  python-virtualenv 

RUN pip install virtualenv-tools && \
    pip install --upgrade pip 
RUN gem install fpm --no-doc 

RUN mkdir -p ${BUILDDIR}${INSTALLDIR}

RUN virtualenv ${BUILDDIR}${INSTALLDIR}/elastalert && \
    $BUILDDIR$INSTALLDIR/elastalert/bin/pip install --upgrade pip && \
    $BUILDDIR$INSTALLDIR/elastalert/bin/pip install "setuptools>=11.3" "elasticsearch>=5.0.0" "urllib3==1.21.1" && \
    $BUILDDIR$INSTALLDIR/elastalert/bin/pip install "elastalert==${Version}" 

