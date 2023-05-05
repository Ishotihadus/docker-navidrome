FROM debian:bookworm-slim

RUN useradd -lmUs /bin/false user && \
    \
    sed -i -e's/Components: main/Components: main contrib non-free non-free-firmware/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get upgrade && \
    apt-get install -y \
    libmp3lame-dev \
    libfdk-aac-dev \
    libvorbis-dev \
    libopus-dev \
    && \
    savedAptMark="$(apt-mark showmanual)" && \
    \
    apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    libgnutls28-dev \
    libtool \
    libwavpack-dev \
    meson \
    ninja-build \
    pkg-config \
    texinfo \
    yasm \
    zlib1g-dev \
    && \
    \
    curl -L https://ffmpeg.org/releases/ffmpeg-6.0.tar.gz | tar xzvf - -C /tmp && \
    cd /tmp/ffmpeg-6.0 && \
    ./configure --enable-gpl --enable-nonfree --enable-libmp3lame --enable-libfdk-aac --enable-libvorbis --enable-libopus --disable-ffplay --disable-doc && \
    make install && \
    cd / && \
    \
    install -d -o user -g user /opt/navidrome && install -d -o user -g user /var/lib/navidrome && \
    curl -L https://github.com/navidrome/navidrome/releases/download/v0.49.3/navidrome_0.49.3_Linux_$(dpkg --print-architecture).tar.gz | tar xzvf - -C /opt/navidrome/ && \
    chown -R user:user /opt/navidrome && \
    \
    apt-mark auto '.*' > /dev/null && \
    apt-mark manual $savedAptMark && \
    find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd {} \; \
    | awk '/=>/ { print $(NF-1) }' | sort -u | grep -vE '^/usr/local/lib/' \
    | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual && \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    apt-get -y purge --auto-remove --allow-remove-essential apt && \
    rm -rf /var/log/* /usr/include /usr/local/include

ENV GODEBUG=asyncpreemptoff=1
WORKDIR /var/lib/navidrome
USER user

ENTRYPOINT ["/opt/navidrome/navidrome"]
