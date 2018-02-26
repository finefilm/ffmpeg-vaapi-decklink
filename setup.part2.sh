#!/bin/bash

# Create directories
mkdir -p $HOME/bin
chown -Rc $USER:$USER $HOME/bin
mkdir -p $HOME/ffmpeg
mkdir -p $HOME/ffmpeg/sources
chown -Rc $USER:$USER $HOME/ffmpeg

export MY_DISTRO_PREFIX=/usr
export MY_DISTRO_LIBDIR=/usr/lib/x86_64-linux-gnu

# Bulid and install NASM assembler latest version - http://www.nasm.us/
cd $HOME/ffmpeg/sources
git clone http://repo.or.cz/nasm.git
cd nasm
sudo ./autogen.sh
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install Yasm Modular Assembler latest version - http://yasm.tortall.net/
cd $HOME/ffmpeg/sources
git clone http://github.com/yasm/yasm.git
cd yasm
./autogen.sh
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install LibVPX video codec latest version - https://www.webmproject.org/code/
cd $HOME/ffmpeg/sources
git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
--cpu=native --as=yasm
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install x264 video codec latest version - https://www.videolan.org/developers/x264.html
cd $HOME/ffmpeg/sources
git clone http://git.videolan.org/git/x264.git
cd x264
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR --enable-static 
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install x265 video codec latest version - http://x265.org/
cd $HOME/ffmpeg/sources
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
PATH="$MY_DISTRO_PREFIX:$PATH" cmake -G "Unix Makefiles" --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR -DENABLE_SHARED:bool=off ../../source
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install Fraunhofer FDK AAC audio codec latest version - https://www.iis.fraunhofer.de/en/ff/amm/impl.html
cd $HOME/ffmpeg/sources
git clone https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --disable-shared
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install Vorbis audio codec latest version - https://www.xiph.org/vorbis/
cd $HOME/ffmpeg/sources
git clone http://git.xiph.org/vorbis.git
cd vorbis
./autogen.sh
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --enable-static --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install LAME MP3 audio codec 3.100 version - http://lame.sourceforge.net/
cd $HOME/ffmpeg/sources
wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" --disable-shared --enable-nasm
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)
make -j$(nproc) install

# Build and install Opus audio codec latest version - http://opus-codec.org/
cd $HOME/ffmpeg/sources
git clone https://github.com/xiph/opus.git
cd opus
./autogen.sh
PATH="$MY_DISTRO_PREFIX:$PATH" ./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --disable-shared
PATH="$MY_DISTRO_PREFIX:$PATH" make -j$(nproc)LAME MP3 audio
make -j$(nproc) install

# Build and install FFmpeg latest version with VAAPI and BMD Decklink support - https://www.ffmpeg.org/
cd $HOME/ffmpeg/sources
git clone https://github.com/FFmpeg/FFmpeg -b master
cd FFmpeg
PATH="$MY_DISTRO_PREFIX:$PATH" PKG_CONFIG_PATH="$MY_DISTRO_PREFIX/lib/pkgconfig" ./configure \
  --pkg-config-flags="--static" \
  --prefix="$HOME/bin" \
  --extra-cflags="-I$MY_DISTRO_PREFIX/include -I$HOME/decklink" \
  --extra-ldflags="-L$MY_DISTRO_LIBDIR" \
  --bindir="$MY_DISTRO_PREFIX/bin" \
  --enable-decklink \
  --enable-debug=3 \
  --enable-vaapi \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-gpl \
  --enable-libass \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --cpu=native \
  --enable-opengl \
  --enable-libfdk-aac \
  --enable-libx264 \
  --enable-libx265 \
  --extra-libs=-lpthread \
  --enable-nonfree 
PPATH="$HOME/bin:$PATH" make -j$(nproc)
make -j$(nproc) install
hash -r

rm -R $HOME/ffmpeg