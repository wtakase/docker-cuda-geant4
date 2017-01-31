FROM wtakase/cuda:8.0-centos7
MAINTAINER wtakase <wataru.takase@kek.jp>

RUN yum update -y
RUN yum groupinstall -y "X Window System"
RUN yum groupinstall -y "Development Tools"
RUN yum install -y gcc-c++ tar expat-devel libXmu-devel libXt-devel \
                   freeglut-devel qt-devel cmake make libX11-devel \
                   libXpm-devel libXft-devel libXext-devel boost-devel zsh vim

ENV HOME /root
WORKDIR /root

ENV ROOT_VERSION 5.34.36
RUN mkdir -p /opt/root/{src,build} && \
    curl -o /opt/root/root_v${ROOT_VERSION}.source.tar.gz \
            https://root.cern.ch/download/root_v${ROOT_VERSION}.source.tar.gz && \
    tar zxf /opt/root/root_v${ROOT_VERSION}.source.tar.gz -C /opt/root/src && \
    rm -f /opt/root/root_v${ROOT_VERSION}.source.tar.gz && \
    cd /opt/root/build && \
    cmake -DCMAKE_INSTALL_PREFIX=../ ../src/root && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    rm -rf /opt/root/{src,build} && \
    echo ". /opt/root/bin/thisroot.sh" > /etc/profile.d/root.sh 

RUN mkdir -p /opt/cmake/src && \
    curl -o /opt/cmake/cmake-3.7.1.tar.gz \
            https://cmake.org/files/v3.7/cmake-3.7.1.tar.gz && \
    tar zxf /opt/cmake/cmake-3.7.1.tar.gz -C /opt/cmake/src && \
    rm -f /opt/cmake/cmake-3.7.1.tar.gz && \
    cd /opt/cmake/src/cmake-3.7.1 && \
    ./configure --prefix=/opt/cmake && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    rm -rf /opt/cmake/src && \
    echo "export PATH=/opt/cmake/bin:$PATH" >> /etc/profile.d/cmake.sh

ENV GEANT4_VERSION 10.03
RUN export PATH=/opt/cmake/bin:$PATH && \
    mkdir -p /opt/geant4/{src,build} && \
    curl -o /opt/geant4/geant4.${GEANT4_VERSION}.tar.gz \
            http://geant4.cern.ch/support/source/geant4.${GEANT4_VERSION}.tar.gz && \
    tar zxf /opt/geant4/geant4.${GEANT4_VERSION}.tar.gz -C /opt/geant4/src && \
    rm -f /opt/geant4/geant4.${GEANT4_VERSION}.tar.gz && \
    cd /opt/geant4/build && \
    cmake -DGEANT4_INSTALL_DATA=on \
          -DGEANT4_USE_OPENGL_X11=on \
          -DGEANT4_USE_QT=on \
          -DCMAKE_INSTALL_PREFIX=../ \
          ../src/geant4.${GEANT4_VERSION} && \
    make -j`grep -c processor /proc/cpuinfo` && \
    make install && \
    rm -rf /opt/geant4/{src,build} && \
    echo ". /opt/geant4/bin/geant4.sh" > /etc/profile.d/geant4.sh

CMD /run.sh
