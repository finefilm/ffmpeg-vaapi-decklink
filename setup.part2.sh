#!/bin/bash

# Create directories
echo "Creating folder for source files"
mkdir -p /tmp/ffmpeg
mkdir -p /tmp/ffmpeg/sources
chown -Rc $USER:$USER /tmp/ffmpeg

# Exporting system variables
echo "Setting environmental variables"
export MY_DISTRO_PREFIX=/usr
export MY_DISTRO_LIBDIR=/usr/lib/x86_64-linux-gnu
export PATH="$MY_DISTRO_PREFIX:$PATH"

# Bulid and install NASM assembler latest version - http://www.nasm.us/
cd /tmp/ffmpeg/sources
echo "Downloading NASM assembler latest version"
git clone http://repo.or.cz/nasm.git > /dev/null
cd nasm
echo "Configuring NASM"
sudo ./autogen.sh > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding NASM"
make -j$(nproc) > /dev/null
echo "Installing NASM"
sudo make -j$(nproc) install > /dev/null

# Build and install Yasm Modular Assembler latest version - http://yasm.tortall.net/
cd /tmp/ffmpeg/sources
echo "Downloading Yasm Modular Assembler latest version"
git clone http://github.com/yasm/yasm.git > /dev/null
cd yasm
echo "Configuring Yasm"
./autogen.sh > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding Yasm"
make -j$(nproc) > /dev/null
echo "Installing Yasm"
sudo make -j$(nproc) install > /dev/null

# Build and install LibVPX video codec latest version - https://www.webmproject.org/code/
cd /tmp/ffmpeg/sources
echo "Downloading LibVPX video codec latest version"
git clone https://chromium.googlesource.com/webm/libvpx > /dev/null
cd libvpx
echo "Configuring LibVPX"
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
--cpu=native --as=yasm > /dev/null
echo "Buliding LibVPX"
make -j$(nproc) > /dev/null
echo "Installing LibVPX"
sudo make -j$(nproc) install > /dev/null

# Build and install x264 video codec latest version - https://www.videolan.org/developers/x264.html
cd /tmp/ffmpeg/sources
echo "Downloading x264 video codec latest version"
git clone http://git.videolan.org/git/x264.git > /dev/null
cd x264
echo "Configuring x264"
./configure --prefix=$MY_DISTRO_PREFIX --bindir="$MY_DISTRO_PREFIX/bin" --libdir=$MY_DISTRO_LIBDIR --enable-static > /dev/null
echo "Buliding x264"
make -j$(nproc) > /dev/null
echo "Installing x264"
sudo make -j$(nproc) install > /dev/null

# Build and install x265 video codec latest version - http://x265.org/
cd /tmp/ffmpeg/sources
echo "Downloading x265 video codec latest version"
hg clone https://bitbucket.org/multicoreware/x265 > /dev/null
cd x265/build/linux
echo "Configuring x265"
cmake -G "Unix Makefiles" --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR -DENABLE_SHARED:bool=off ../../source > /dev/null
echo "Buliding x265"
make -j$(nproc) > /dev/null
echo "Installing x265"
sudo make -j$(nproc) install > /dev/null

# Build and install Fraunhofer FDK AAC audio codec latest version - https://www.iis.fraunhofer.de/en/ff/amm/impl.html
cd /tmp/ffmpeg/sources
echo "Downloading Fraunhofer FDK AAC audio codec latest version"
git clone https://github.com/mstorsjo/fdk-aac > /dev/null
cd fdk-aac
echo "Configuring FDK-AAC"
autoreconf -fiv > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --disable-shared > /dev/null
echo "Buliding FDK-AAC"
make -j$(nproc) > /dev/null
echo "Installing FDK-AAC"
sudo make -j$(nproc) install > /dev/null

# Build and install Vorbis audio codec latest version - https://www.xiph.org/vorbis/
cd /tmp/ffmpeg/sources
echo "Downloading Vorbis audio codec latest version"
git clone http://git.xiph.org/vorbis.git > /dev/null
cd vorbis
echo "Configuring Vorbis"
./autogen.sh > /dev/null
./configure --enable-static --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR > /dev/null
echo "Buliding Vorbis"
make -j$(nproc) > /dev/null
echo "Installing Vorbis"
sudo make -j$(nproc) install > /dev/null

# Build and install LAME MP3 audio codec 3.100 version - http://lame.sourceforge.net/
cd /tmp/ffmpeg/sources
echo "Downloading LAME MP3 audio codec 3.100 version"
wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz > /dev/null
tar xzvf lame-3.100.tar.gz > /dev/null
cd lame-3.100
echo "Configuring LAME 3.100"
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --bindir="$MY_DISTRO_PREFIX/bin" --disable-shared --enable-nasm > /dev/null
echo "Buliding LAME 3.100"
make -j$(nproc) > /dev/null
echo "Installing LAME 3.100"
sudo make -j$(nproc) install > /dev/null

# Build and install Opus audio codec latest version - http://opus-codec.org/
cd /tmp/ffmpeg/sources
echo "Downloading Opus audio codec latest version"
git clone https://github.com/xiph/opus.git > /dev/null
cd opus
echo "Configuring Opus"
./autogen.sh > /dev/null
./configure --prefix=$MY_DISTRO_PREFIX --libdir=$MY_DISTRO_LIBDIR --disable-shared > /dev/null
echo "Buliding Opus"
make -j$(nproc)LAME MP3 audio > /dev/null
echo "Installing Opus"
sudo make -j$(nproc) install > /dev/null

# Build and install FFmpeg latest version with VAAPI and BMD Decklink support - https://www.ffmpeg.org/
cd /tmp/ffmpeg/sources
echo "Downloading FFmpeg latest version"
git clone https://github.com/FFmpeg/FFmpeg -b master > /dev/null
cd FFmpeg
echo "Configuring FFmpeg with VAAPI and BMD Decklink support"
PKG_CONFIG_PATH="$MY_DISTRO_PREFIX/lib/pkgconfig" ./configure \
  --pkg-config-flags="--static" \
  --prefix=$MY_DISTRO_PREFIX \
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
  --enable-nonfree > /dev/null
echo "Buliding FFmpeg"
make -j$(nproc) > /dev/null
echo "Installing FFmpeg"
sudo make -j$(nproc) install > /dev/null
hash -r