FROM debian:stretch-slim as builder

# Make sure we don't get notifications we can't answer during building.
ENV DEBIAN_FRONTEND=noninteractive \
    OctavePath=/opt/octave-${OctaveVersion} \
    OctaveVersion=4.4.1

LABEL maintainer="Jonathan Goldfarb <jgoldfar@my.fit.edu>"

RUN apt-get -qq -y update && \
    apt-get -q -y --no-install-recommends install \
      build-essential \
      libgfortran-6-dev \
      curl \
      libcurl4-openssl-dev \
      make \
      ca-certificates \
      autoconf \
      automake \
      # This is necessary for autoreconf
      libtool-bin \
      texinfo \
      gnuplot \ 
      icoutils \
      bison \
      flex \
      patch \
      gperf \
      zip \
      ghostscript \
      # hdf5
      libhdf5-serial-dev \
      libpcre3-dev \
      libreadline-dev \
      libglpk-dev \
      libqrupdate-dev \
      libqhull-dev \
      libfftw3-dev \
      libgl2ps-dev \
      libarpack2-dev \
      libsuitesparse-dev \
      libopenblas-dev \
      # Graphics
      libgs-dev \
      libgraphicsmagick++ \
      libgraphicsmagick++1-dev \
      libfltk1.3-dev \
      libgl1-mesa-dev \
      libglu1-mesa-dev \
      freeglut3-dev \
      libfreetype6-dev \
      libfontconfig1-dev \
      librsvg2-bin \
      libosmesa6-dev \
      # GUI
      qttools5-dev \
      libqt5core5a \
      libqt5gui5 \
      libqt5help5 \
      libqt5network5 \
      libqt5opengl5-dev \
      libqt5scintilla2-dev \
      libqscintilla2-dev \
      libqt5webkit5-dev \
      libxft-dev \
      # Sundials
      libsundials-serial-dev

ADD getcwd-path-max.patch /tmp/

RUN mkdir -p ${OctavePath} && \
    curl -o /tmp/octave-${OctaveVersion}.tar.xz https://ftp.gnu.org/gnu/octave/octave-${OctaveVersion}.tar.xz && \
    tar xJf /tmp/octave-${OctaveVersion}.tar.xz --directory ${OctavePath} --strip-components 1

#TODO: Re-add make check step
# ( make check || echo "Tests Failed." )

RUN cd ${OctavePath} && \
    patch -p2 < /tmp/getcwd-path-max.patch && \
    autoreconf -i -f && \
    ./configure --disable-docs && \
    make -j3 install
# End builder image

## 
##
##

FROM debian:stretch-slim as gui
RUN apt-get -qq -y update && \
    apt-get -qq -y --no-install-recommends install \
      texinfo \
      ghostscript \
      gnuplot \
      curl \
      # Build-essential related
      libgomp1 \
      libcurl4-openssl-dev \
      libgfortran-6-dev \
      libhdf5-serial-dev \
      libquadmath0 \
      libqhull7 \
      # Linear Algebra
      libsuitesparseconfig4 \
      # AMD
      libamd2 \
      libcamd2 \
      libcolamd2 \
      libccolamd2 \
      # Other LA
      libumfpack5 \
      libqrupdate1 \
      libcholmod3 \
      libarpack2 \
      libopenblas-base \
      libcxsparse3 \
      # FFTW
      libfftw3-double3 \
      libfftw3-single3 \
      # Graphical Output
      libfltk-gl1.3 \
      libfltk1.3 \
      libfontconfig1 \
      libfreetype6 \
      libgl2ps1 \
      libgl1-mesa-glx \
      libglu1-mesa \
      libosmesa6 \
      # CLI
      libreadline7 \
      # QT
      libqscintilla2-12v5 \
      libqt5core5a \
      libqt5help5 \
      libqt5gui5 \
      libqt5sql5-sqlite \
      libqt5network5 \
      libqt5webkit5 \
      libqt5opengl5 \
      # Sundials
      libsundials-serial \
      libklu1 \
      libbtf1 \
      # For Octave installation
      equivs \
      # Others
      libgraphicsmagick++-q16-12 \
      libgraphicsmagick-q16-3 \
      liblcms2-2 \
      libnghttp2-14 \
      libidn2-0 \
      librtmp1 \
      libssh2-1 \
      libpsl5 \
      libmetis5 \
      libunistring0 \
      libsasl2-2 \
      libldap-2.4-2 \
      libsz2 \
      libwebpmux2 \
      libwmf0.2-7 \
      libaec0
      

# Set ENV the same as above
ENV OctaveVersion=4.4.1 \
    DISPLAY=:0

# Copy over libs and share files
COPY --from=builder /usr/local/lib/octave /usr/local/lib/octave
COPY --from=builder /usr/local/share/octave /usr/local/share/octave

# Copy over Octave binaries (includes mkoctfile)
COPY --from=builder /usr/local/bin/*oct* /usr/local/bin/
COPY --from=builder /usr/local/libexec/octave /usr/local/libexec/octave

# Copy over Octave docstrings. Note that some paths contain 
# version-specific information.
COPY --from=builder /usr/local/share/octave/${OctaveVersion}/etc/built-in-docstrings /usr/local/share/octave/${OctaveVersion}/etc/

# Copy over Octave include files
COPY --from=builder /usr/local/include/octave-${OctaveVersion} /usr/local/include/octave-${OctaveVersion}

# Copy over necessary fonts
COPY --from=builder /usr/local/share/octave/${OctaveVersion}/fonts/* /usr/local/share/octave/${OctaveVersion}/fonts/

# Copy over Octave STDLIB (m-files)
COPY --from=builder /usr/local/share/octave/${OctaveVersion}/m /usr/local/share/octave/${OctaveVersion}/m

# Copy over Octave site packages
COPY --from=builder /usr/local/share/octave/site/* /usr/local/share/octave/site/

# NOTE: Manfiles and docs not copied because they weren't built!

# Install octave package as equiv package
COPY octave-local.tpl /tmp/octave-equivs/octave-local.tpl

RUN cd /tmp/octave-equivs && \
    equivs-control octave-local && \
    sed 's/__VER__/${OctaveVersion}/' octave-local.tpl > octave-local && \
    cat octave-local && \
    equivs-build octave-local && \
    dpkg -i octave-local_*.deb

ADD ./qt-settings /root/.config/octave/qt-settings

RUN apt-get -qq -y remove \
      equivs && \
    apt-get -qq -y autoremove && \
    apt-get autoclean && \
    cd / && \
    rm -rf \
      /var/lib/apt/lists/* \
      /var/log/dpkg.log && \
    octave --version && \
    octave --eval "disp(eye(2) \ [1, 10]');" && \
    octave --eval "hf = figure(); x=linspace(0,1,30); plot(x, erf(x)); print(hf, 'plot.eps', '-deps');"
    

# Set entrypoint (so this image can be used as an executable.)
ENTRYPOINT ["/usr/local/bin/octave"]
