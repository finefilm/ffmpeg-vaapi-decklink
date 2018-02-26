#!/bin/bash

sudo apt-get update -qq
sudo apt-get upgrade -y
sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  cmake-curses-gui \
  git \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtheora-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  gcc-arm-linux-gnueabi \
  g++-arm-linux-gnueabi \
  mercurial \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  ssh \
  tcl


# Create directories
mkdir -p $HOME/bin
chown -Rc $USER:$USER $HOME/bin
mkdir -p ~/ffmpeg
mkdir -p ~/ffmpeg/sources
mkdir -p ~/vaapi
mkdir -p ~/vaapi/sources

# Download recent BMD Decklink SDK
cd ~
git clone http://github.com/finefilm/decklink

# Download and install recent BMD Desktop Video driver and GUI and Media Express
cd ~
git clone https://github.com/finefilm/desktopvideo
cd desktopvideo
sudo dpkg -i desktopvideo_*.deb
sudo dpkg -i desktopvideo-gui_*.deb
sudo dpkg -i mediaexpress_*.deb

# Bulid and install NASM assembler latest version - http://www.nasm.us/
cd ~/ffmpeg/sources
git clone http://repo.or.cz/nasm.git
cd nasm
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --bindir="$HOME/bin"
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install Yasm Modular Assembler latest version - http://yasm.tortall.net/
cd ~/ffmpeg/sources
git clone http://github.com/yasm/yasm.git
cd yasm
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --bindir="$HOME/bin"
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install  C for Media Runtime latest version - https://github.com/intel/cmrt
cd ~/vaapi/sources
git clone https://github.com/01org/cmrt
cd cmrt
./autogen.sh
./configure
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean
sudo ldconfig -vvvv

# Build and install VA driver for Intel G45 & HD Graphics family latest version - https://github.com/01org/intel-hybrid-driver
cd ~/vaapi/sources
git clone https://github.com/01org/intel-hybrid-driver
cd intel-hybrid-driver
./autogen.sh
./configurev
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean
sudo ldconfig -vvvv

# Build and install VA-API user mod driver latest version - https://github.com/01org/intel-hybrid-driver
cd ~/vaapi/sources
git clone https://github.com/01org/intel-vaapi-driver
cd intel-vaapi-driver
./autogen.sh
./configure --enable-hybrid-codec
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean
sudo ldconfig -vvvv

# Build and install VA-API latest version - https://github.com/01org/libva
cd ~/vaapi/sources
git clone https://github.com/01org/libva
cd libva
./autogen.sh
./configure
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install x264 video codec latest version - https://www.videolan.org/developers/x264.html
cd ~/ffmpeg/sources
git clone http://git.videolan.org/git/x264.git
cd x264
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --bindir="$HOME/bin" --enable-static 
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install x264 video codec latest version - http://x265.org/
cd ~/ffmpeg/sources
hg clone https://bitbucket.org/multicoreware/x265
cd x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/bin" -DENABLE_SHARED:bool=off ../../source
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean


# Build and install LibVPX video codec latest version - https://www.webmproject.org/code/
cd ~/ffmpeg/sources
git clone https://chromium.googlesource.com/webm/libvpx
cd libvpx
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
--cpu=native --as=yasm
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install Fraunhofer FDK AAC audio codec latest version - https://www.iis.fraunhofer.de/en/ff/amm/impl.html
cd ~/ffmpeg/sources
git clone https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --disable-shared
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install Vorbis audio codec latest version - https://www.xiph.org/vorbis/
cd ~/ffmpeg/sources
git clone http://git.xiph.org/vorbis.git
cd vorbis
PATH="$HOME/bin:$PATH" ./configure --enable-static --prefix="$HOME/bin"
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

# Build and install LAME MP3 audio codec 3.100 version - http://lame.sourceforge.net/
cd ~/ffmpeg/sources
wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --bindir="$HOME/bin" --disable-shared --enable-nasm
PATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean

cd ~/ffmpeg/sources
git clone https://github.com/xiph/opus.git
cd opus
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/bin" --disable-shared
PPATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean


# Build and install FFmpeg latest version with VAAPI and BMD Decklink support - https://www.ffmpeg.org/
cd ~/ffmpeg/sources
git clone https://github.com/FFmpeg/FFmpeg -b master
cd FFmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/bin/lib/pkgconfig" ./configure \
  --pkg-config-flags="--static" \
  --prefix="$HOME/bin" \
  --extra-cflags="-I$HOME/bin/include" \
  --extra-ldflags="-L$HOME/bin/lib" \
  --extra-cflags="-I$HOME/decklink" \
  --extra-ldflags="-L$HOME/decklink" \
  --bindir="$HOME/bin" \
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
PPATH="$HOME/bin:$PATH" sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo make -j$(nproc) clean 
sudo make -j$(nproc) distclean
hash -r





